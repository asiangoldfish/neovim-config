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
    export PATH="$PATH:$GOROUTE/bin"
fi

# go application binaries (installed with 'go install')
if [ -d "$HOME/go/bin" ]; then
    export PATH="$PATH:$HOME/go/bin"
fi
