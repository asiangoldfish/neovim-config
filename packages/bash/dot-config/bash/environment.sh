# environment.sh
#
# Environment variables for Bash interactive shell.

# Neovim
export EDITOR='nvim'

# Cargo
if [ -d "$HOME/.cargo/" ]; then
    source "$HOME/.cargo/env"
fi

# Python pyenv
if [ -d "$HOME/.pyenv" ]; then
    export PYENV_ROOT="$HOME/.pyenv"
    [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
fi

# Haskell toolchain
[ -f "/home/khai/.ghcup/env" ] && source "/home/khai/.ghcup/env"

# Git
## Required for cloning the Neovim ahmedkhalf/project.nvim plugin
export GIT_TERMINAL_PROMPT=1

# Ruby
if [ -d "$HOME/gems" ]; then
    export GEM_HOME="$HOME/gems"
    export PATH="$HOME/gems/bin:$PATH"
fi

if [ -d "$HOME/.guix-profile/lib/locale" ]; then
    export GUIX_LOCPATH="$HOME/.guix-profile/lib/locale"
    GUIX_PROFILE="$HOME/.config/guix/current"
    . "$GUIX_PROFILE/etc/profile"
fi

# Pyenv
if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init - bash)"
fi
