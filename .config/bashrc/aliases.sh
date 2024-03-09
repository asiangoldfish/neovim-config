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

### ARCHIVE EXTRACTION
# usage: ex <file>
# Source: Derek Taylor at https://gitlab.com/dwt1/dotfiles/-/blob/master/.bashrc
function extract ()
{
    function ex_help() {
    cat << 'HELP'
extract - Extract function

Usage: extract <file>

Description:
The 'extract' function is designed to extract various types of compressed files. It automatically detects the file format and extracts it accordingly.

Supported File Formats:
- *.tar.bz2:   Extracts files compressed with tar and bzip2 compression.
- *.tar.gz:    Extracts files compressed with tar and gzip compression.
- *.bz2:       Extracts files compressed with bzip2 compression.
- *.rar:       Extracts files compressed with RAR compression.
- *.gz:        Extracts files compressed with gzip compression.
- *.tar:       Extracts files compressed with tar.
- *.tbz2:      Extracts files compressed with tar and bzip2 compression.
- *.tgz:       Extracts files compressed with tar and gzip compression.
- *.zip:       Extracts files compressed with ZIP compression.
- *.Z:         Extracts files compressed with compress.
- *.7z:        Extracts files compressed with 7z compression.
- *.deb:       Extracts Debian packages.
- *.tar.xz:    Extracts files compressed with tar and xz compression.
- *.tar.zst:   Extracts files compressed with tar and zstd compression.

Parameters:
<file>: The file to be extracted.

Examples:
- extract example.tar.gz
- extract document.zip
HELP
    }


    if [ -f "$1" ] ; then
        case $1 in
        *.tar.bz2)   tar xjf $1   ;;
        *.tar.gz)    tar xzf $1   ;;
        *.bz2)       bunzip2 $1   ;;
        *.rar)       unrar x $1   ;;
        *.gz)        gunzip $1    ;;
        *.tar)       tar xf $1    ;;
        *.tbz2)      tar xjf $1   ;;
        *.tgz)       tar xzf $1   ;;
        *.zip)       unzip $1     ;;
        *.Z)         uncompress $1;;
        *.7z)        7z x $1      ;;
        *.deb)       ar x $1      ;;
        *.tar.xz)    tar xf $1    ;;
        *.tar.zst)   unzstd $1    ;;
        *)           echo "'$1' cannot be extracted via extract" ;;
        esac
    else
        ex_help | less
    fi
}
