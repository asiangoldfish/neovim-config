# Custom scripts
if [ -d "$HOME/bin" ]; then
    export PATH="$PATH:$HOME/bin"
fi

# Zotero- Manage citations for research and academic writing
if [ -d "$HOME/bin/Zotero_linux-x86_64" ]; then
    export PATH="$PATH:$HOME/bin/Zotero_linux-x86_64"
fi

# Flatpak- Software package manager
if [ -d "/var/lib/flatpak/exports/bin" ]; then
    export PATH="$PATH:/var/lib/flatpak/exports/bin"
fi

# Binaries for the user only
if [ -d ".local/bin" ]; then
    export PATH="$PATH:~/.local/bin"
fi

# golang binary (ex. go toolchain)
if [ -d ".local/bin/go/bin" ]; then
    export GOROOT="$HOME/.local/bin/go"
    export PATH="$PATH:$GOROOT/bin"
fi

# go application binaries (installed with 'go install')
if [ -d "$HOME/go/bin" ]; then
    export PATH="$PATH:$HOME/go/bin"
fi

# Ruby gems
if [ -d "$HOME/gems" ]; then
    if [ -z "$XDG_CONFIG_HOME" ]; then
	XDG_CONFIG_HOME="$HOME/.config"
    fi

    export GEM_HOME="$XDG_CONFIG_HOME/gems"
    export PATH="$GEM_HOME/bin:$PATH"
fi

# Rust rover
if [ -d "$HOME/repos/rust-rover/bin" ]; then
    export PATH="$PATH:$HOME/repos/rust-rover/bin"
fi

if [ -d "$HOME/.zig" ]; then
    export PATH="$PATH:$HOME/.zig"
fi
