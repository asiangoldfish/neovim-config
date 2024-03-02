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