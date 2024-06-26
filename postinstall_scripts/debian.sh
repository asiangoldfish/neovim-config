#!/usr/bin/env bash

### Essential updates
# Packages that are mostly installed with apt goes here. They do not include
# dependencies, unless necessary to install an essential package.
function install_essentials() {
    if command -v thunderbird > /dev/null; then
        return;
    fi

    # apt frontend
    echo "Installing nala..."
    sudo apt install nala -y

    # fish omitted
    echo "Installing essentials..."
    sudo nala install -y \
        vim git curl stow yad sxhkd cmake emacs feh picom ripgrep rofi \
        ranger polybar

        # For latex support...
        # Look https://emacs.stackexchange.com/a/73197 for more info on
        # rendering Latex on emacs
    sudo nala install -y texlive-latex-extra

    # Fonts
    sudo nala install -y fonts-cantarell fonts-jetbrains-mono

    # PDF converters
    sudo nala install -y pandoc

    # Email clients
    sudo nala install -y thunderbird

    # Screenshots
    sudo nala install -y flameshot

    # Bluetooth
    sudo nala install -y blueman

    # Python
    sudo nala install -y libreadline-dev tk-dev

    # Binaries only for the user
    mkdir -p ~/.local/bin

    # File management
    sudo nala install -y fzf

    # Development
    sudo nala install -y meson

    # Ensure gems directory exists to Ruby gems install packages locally
    mkdir -p "$HOME/gems"
}

function install_rust() {
    command -v ~/.cargo/bin/rustup > /dev/null && return
    echo "Installing rust..."
    RUSTUP_INIT_SKIP_PATH_CHECK=yes curl https://sh.rustup.rs -sSf | sh -s -- 
}

function install_alacritty() {
    command -v ~/.cargo/bin/alacritty > /dev/null && return
    # Install essential: Alacritty
    sudo nala install -y \
        pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev \
        libxkbcommon-dev python3
    sudo nala install -y cargo

 #   echo "Installing alacritty..."
    # Get updated rust version
    # TODO: Fix this part. This tends to break for some reason (Incorrect rust version)
#    sleep 1
  #  ~/.cargo/bin/rustup override set stable
   # ~/.cargo/bin/rustup update stable¨
    #alias rustc='~/.cargo/bin/rustc'
    #~/.cargo/bin/cargo install alacritty
}

function install_window_manager() {
    # i3
    command -v i3 > /dev/null && return

    # Some distros have outdated i3. Ubuntu and its derivatives
    # on stable version have very outdated versions of i3. So
    # we just built it ourselves.

    # Get distro name
    source /etc/os-release

    "$NAME"

    if [ -z "$NAME" ]; then # Empty name. Don't install i3
        return 1
    fi

    echo "Installing i3..."

    if [ "$NAME" == "Debian GNU/Linux" ]; then
        sudo nala install -y i3 --no-install-recommends
    else
        sudo nala install -y build-essential zlib1g-dev libffi-dev libssl-dev libbz2-dev libreadline-dev libsqlite3-dev liblzma-dev ninja meson
        
        if [ ! -d "$HOME/Downloads" ]; then mkdir "$HOME/Downloads"; fi
        git clone https://github.com/i3/i3.git
        cd i3
        mkdir -p build && cd build
        meson ..
        ninja

        # TODO: Post-installation (.application, mv to /usr/i3, ...)
    fi


}

function install_dotfiles() {
    if [ -d "$HOME/dotfiles" ]; then
        return
    fi

    echo "Cloning dotfiles from GitHub..."
    # Edit the URL if to use your own config
    git clone --recurse-submodules https://github.com/asiangoldfish/neovim-config.git ~/dotfiles
    cd ~/dotfiles

    # Overwrite existing files
    echo "Deploying dotfiles from ~/dotfiles"
    stow --adopt .
    git reset
    stow .
}

function install_haskell() {
    command -v .ghcup/bin/ghcup > /dev/null && return
    # Installing Haskell toolchains
    # Source: https://stackoverflow.com/a/72953383
    sudo nala install -y build-essential curl libffi-dev libffi8ubuntu1 libgmp-dev libgmp10 libncurses-dev libncurses5 libtinfo5
    curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | BOOTSTRAP_HASKELL_NONINTERACTIVE=1 BOOTSTRAP_HASKELL_GHC_VERSION=latest BOOTSTRAP_HASKELL_CABAL_VERSION=latest BOOTSTRAP_HASKELL_INSTALL_STACK=1 BOOTSTRAP_HASKELL_INSTALL_HLS=1 BOOTSTRAP_HASKELL_ADJUST_BASHRC=P sh
}

function install_discord() {
    command -v discord > /dev/null && return

    mkdir -p ~/Downloads
    cd ~/Downloads
    wget "https://discord.com/api/download?platform=linux&format=deb" -O discord.deb
    sudo nala install -y ./discord.deb
}

function install_golang() {
    command -v go > /dev/null && return
    if [ -d "$HOME/.local/bin/go" ]; then
        return
    fi

    cd ~/Downloads
    wget 'https://go.dev/dl/go1.22.1.linux-amd64.tar.gz'
    sudo tar -C ~/.local/bin -xzf 'go1.22.1.linux-amd64.tar.gz'
}

function install_lazygit() {
    if [ -f "$HOME/go/bin/lazygit" ]; then
        return;
    fi

    go install github.com/jesseduffield/lazygit@latest
}

function install_vscode() {
    command -v code > /dev/null && return

    # Get pgp key
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    sudo install -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/microsoft-archive-keyring.gpg
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

    # Install with apt
    sudo nala update
    sudo nala install -y code
}

function install_neovim() {
    command -v nvim > /dev/null && return

    # Build instructions from 
    # https://github.com/neovim/neovim/blob/master/BUILD.md
    sudo nala install ninja-build gettext cmake unzip curl build-essential
    
    if [ ! -d "$HOME/Downloads" ]; then
        mkdir "$HOME/Downloads"
    fi
    cd ~/Downloads
    git clone https://github.com/neovim/neovim
    cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo
    cd build && cpack -G DEB && sudo dpkg -i nvim-linux64.deb
}

function install_gtk3_dev() {
    if [ ! -z "$(nala list -i | grep python3-gi)" ]; then
        return
    fi

    sudo nala install -y python3-gi
}

function install_dotfiles_config() {
    sudo nala install
    git clone https://github.com/asiangoldfish/neovim-config.git $HOME/dotfiles
    cd ~/dotfiles
    stow --adopt
    git reset
    stow .
}


# Prompt confirmation to begin the installation
echo "Post installation for your system is about to begin."
read -n 1 -r -s -p "Press any key to continue, or CTRL+C to cancel..."

set -e # Exit immediately if a command fails.
# The line below does not work
# set -y # Unset variables and parameters fail when used.
# set -x # Echo commands to make debugging easier.
install_rust
install_essentials
install_alacritty
install_window_manager
install_haskell
install_discord
install_golang

# Path needs to include go binary directory before continuing with installing lazygit
export GOROOT="$HOME/.local/bin/go"
export PATH="$PATH:$GOROOT/bin"

install_lazygit
install_vscode
install_neovim
install_gtk3_dev

install_dotfiles

# set +x

# Message to install alacritty
if ! command -v ~/.cargo/bin/alacritty > /dev/null; then
    echo ""
    echo "To install alacritty, open a new terminal and run the following command:"
    echo "~/.cargo/bin/cargo install alacritty"
fi

# Prompt for reboot
echo ""
echo "Post installation successfully completed!"
echo "It's recommended to reboot with 'systemctl reboot'"
