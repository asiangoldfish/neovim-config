# Interactive mode
case $- in
    *i*) ;;
      *) return;;
esac

# Import modules from $XDG_CONFIG_HOME
# Credits: https://medium.com/codex/how-and-why-you-should-split-your-bashrc-or-zshrc-files-285e5cc3c843
if [ -z "$XDG_CONFIG_HOME" ]; then
    XDG_CONFIG_HOME="$HOME/.config"
fi

if [ -d "$XDG_CONFIG_HOME/bashrc" ]; then
    for FILE in "$XDG_CONFIG_HOME"/bashrc/*; do
        source $FILE
    done
fi

# Bash options
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s checkwinsize

# Debian chroot
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Terminal stuff
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# Colour output
if [ -n "$force_color_prompt" ]; then
    # We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	    color_prompt=yes
    else
	    color_prompt=
    fi
fi

# Colourize the prompt
if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# Default x11 terminal styling
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# Colourized ls
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi


# Bash completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Ignore upper and lowercase when TAB completion
# Source: Derek Taylor at https://gitlab.com/dwt1/dotfiles/-/blob/master/.bashrc
bind "set completion-ignore-case on"
