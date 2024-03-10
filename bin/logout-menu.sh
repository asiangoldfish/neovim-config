#!/usr/bin/bash

TITLE='logout'

function base_yad() {
    args="$1"

    size=''

    yad --title='logout' \
        "$args"
}

# yad --html --browser --uri="https://ntnu.blackboard.com" --no-buttons --geometry=800x500

# yad --list --radiolist \
#         --column "Foo" --column "Bar" \
#         TRUE Apples TRUE Oranges FALSE Pears FALSE Toothpaste \
#     --geometry=800x500 \
#     --close-on-unfocus

# yad --notification --text "System update" --command "alacritty -e firefox"

# yad --notebook

yad --title='logout menu' \
    --button="Logout:pkill -u $(whoami)" \
    --button='Reboot:systemctl reboot' \
    --button='Power Off:systemctl poweroff'
