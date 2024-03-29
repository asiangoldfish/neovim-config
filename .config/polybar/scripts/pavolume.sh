#!/usr/bin/env bash

# finds the active sink for pulse audio and increments the volume. useful when you have multiple audio outputs and have a key bound to vol-up and down

osd='no'
inc='2'
capvol='no'
maxvol='200'
autosync='yes'

# Muted status
# yes: muted
# no : not muted
curStatus="no"
active_sink=""
limit=$((100 - inc))
maxlimit=$((maxvol - inc))

reloadSink() {
    active_sink=$(pacmd list-sinks | awk '/* index:/{print $3}')
}

function volUp {

    getCurVol

    if [ "$capvol" = 'yes' ]
    then
        if [ "$curVol" -le 100 ] && [ "$curVol" -ge "$limit" ]
        then
            pactl set-sink-volume "$active_sink" -- 100%
        elif [ "$curVol" -lt "$limit" ]
        then
            pactl set-sink-volume "$active_sink" -- "+$inc%"
        fi
    elif [ "$curVol" -le "$maxvol" ] && [ "$curVol" -ge "$maxlimit" ]
    then
        pactl set-sink-volume "$active_sink" "$maxvol%"
    elif [ "$curVol" -lt "$maxlimit" ]
    then
        pactl set-sink-volume "$active_sink" "+$inc%"
    fi

    getCurVol

    if [ ${osd} = 'yes' ]
    then
        qdbus org.kde.kded /modules/kosd showVolume "$curVol" 0
    fi

    if [ ${autosync} = 'yes' ]
    then
        volSync
    fi
}

function volDown {

    pactl set-sink-volume "$active_sink" "-$inc%"
    getCurVol

    if [ ${osd} = 'yes' ]
    then
        qdbus org.kde.kded /modules/kosd showVolume "$curVol" 0
    fi

    if [ ${autosync} = 'yes' ]
    then
        volSync
    fi

}

function getSinkInputs {
    input_array=$(pacmd list-sink-inputs | grep -B 4 "sink: $1 " | awk '/index:/{print $2}')
}

function volSync {
    getSinkInputs "$active_sink"
    getCurVol

    for each in $input_array
    do
        pactl set-sink-input-volume "$each" "$curVol%"
    done
}

function getCurVol {
    # curVol=$(pacmd list-sinks | grep -A 15 "index: $active_sink$" | grep 'volume:' | grep -E -v 'base volume:' | awk -F : '{print $3}' | grep -o -P '.{0,3}%'| sed s/.$// | tr -d ' ')
    curVol=$(pactl list sinks | grep '^[[:space:]]Volume:' | head -n $(( $SINK + 1 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,')
}

function volMute {
    case "$1" in
        mute)
            pactl set-sink-mute "$active_sink" 1
            curVol=0
            status=1
            ;;
        unmute)
            pactl set-sink-mute "$active_sink" 0
            getCurVol
            status=0
            ;;
    esac

    if [ ${osd} = 'yes' ]
    then
        qdbus org.kde.kded /modules/kosd showVolume ${curVol} ${status}
    fi

}

function volMuteStatus {
    curStatus=$(pacmd list-sinks | grep -A 15 "index: $active_sink$" | awk '/muted/{ print $2}')
}

function formatVolume {
    echo "Vol: $1%"
}

# Prints output for bar
# Listens for events for fast update speed
function listen {
    firstrun=0
    formatVolume "$(pamixer --get-volume)"; 
    pactl subscribe \
      | grep --line-buffered "Event 'change' on sink " \
      | while read -r evt; 
      do formatVolume "$(pamixer --get-volume | cut -d " " -f1)";
    done
}

# Obsolete?
function output() {
    reloadSink
    getCurVol
    volMuteStatus
    if [ "${curStatus}" = 'yes' ]
    then
        echo "ﱝ mute"
    else
        echo "$curVol"
        if [ $curVol -gt 70 ]; then
            echo "$curVol%"
        elif [ $curVol -gt 30 ]; then
          echo "$curVol%"
        else
          echo "$curVol%"
        fi
    fi
} #}}}

reloadSink
case "$1" in
    --up)
        volUp
        ;;
    --down)
        volDown
        ;;
    --togmute)
        volMuteStatus
        if [ "$curStatus" = 'yes' ]
        then
            volMute unmute
        else
            volMute mute
        fi
        ;;
    --mute)
        volMute mute
        ;;
    --unmute)
        volMute unmute
        ;;
    --sync)
        volSync
        ;;
    --listen)
        # Listen for changes and immediately create new output for the bar
        # This is faster than having the script on an interval
        listen
        ;;
    *)
        # By default print output for bar
        output
        ;;
esac
