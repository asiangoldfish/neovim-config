# Load aliases from the conventional .bash_aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Copy stdout and stderr to X clipboard
alias copy='xsel -ib'

# Git front-end
alias lg='lazygit'

# Neovim
alias vim='nvim'

# apt front-end. Remove if not needed
alias apt='sudo nala'

# Make the shell cd to ranger's browsed directory
function r {
    local IFS=$'\t\n'
    local tempfile="$(mktemp -t tmp.XXXXXX)"
    local ranger_cmd=(
        command
        ranger
        --cmd="map q chain shell echo %d > "$tempfile"; quitall"
    )

    ${ranger_cmd[@]} "$@"
    if [[ -f "$tempfile" ]] && [[ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]]; then
        cd -- "$(cat "$tempfile")" || return
    fi
    command rm -f -- "$tempfile" 2>/dev/null
}