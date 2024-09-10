# environment.sh
#
# Environment variables for Bash interactive shell.

# Neovim
export EDITOR='nvim'

# Cargo
source "$HOME/.cargo/env"

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
if [ -d "$HOME/gems" ];
    export GEM_HOME="$HOME/gems"
    export PATH="$HOME/gems/bin:$PATH"
fi

