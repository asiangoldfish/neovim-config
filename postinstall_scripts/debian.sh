#!/usr/bin/env bash

### Essential updates
# Packages that are mostly installed with apt goes here. They do not include
# dependencies, unless necessary to install an essential package.
function install_essentials() {
    # apt frontend
    echo "Installing nala..."
    sudo apt install nala -y

    echo "Installing essentials..."
    sudo nala install -y \
        vim git curl stow fish yad sxhkd cmake emacs feh picom ripgrep rofi \
        ranger polybar

    # For latex support...
        # Look https://emacs.stackexchange.com/a/73197 for more info on
        # rendering Latex on emacs
    sudo nala install -y dvipna texlive-latex-extra

    # Fonts
    sudo nala install -y fonts-cantarell fonts-jetbrains-mono

    # PDF converter
    sudo nala install -y pandoc

    # Binaries only for the user
    mkdir -p ~/.local/bin
}

function install_rust() {
    echo "Installing rust..."
    RUSTUP_INIT_SKIP_PATH_CHECK=yes curl https://sh.rustup.rs -sSf | sh -s -- 
}

function install_alacritty() {
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
    echo "Installing i3..."
    sudo nala install -y i3 --no-install-recommends
}

function install_dotfiles() {
    echo "Cloning neovim-config..."
    # Edit the URL if to use your own config
    git clone --recurse-submodules https://github.com/asiangoldfish/neovim-config.git ~/dotfiles
    cd ~/dotfiles

    # Overwrite existing files
    echo "Deploying dotfiles from ~/dotfiles"
    stow --adopt
    git restore --hard HEAD
    stow .
}

function install_haskell() {
    # Installing Haskell toolchains
    # Source: https://stackoverflow.com/a/72953383
    sudo nala install -y build-essential curl libffi-dev libffi8ubuntu1 libgmp-dev libgmp10 libncurses-dev libncurses5 libtinfo5
    curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | BOOTSTRAP_HASKELL_NONINTERACTIVE=1 BOOTSTRAP_HASKELL_GHC_VERSION=latest BOOTSTRAP_HASKELL_CABAL_VERSION=latest BOOTSTRAP_HASKELL_INSTALL_STACK=1 BOOTSTRAP_HASKELL_INSTALL_HLS=1 BOOTSTRAP_HASKELL_ADJUST_BASHRC=P sh
}

function install_discord() {
    mkdir -p ~/Downloads
    cd ~/Downloads
    wget "https://discord.com/api/download?platform=linux&format=deb" -O discord.deb
    sudo nala install -y ./discord.deb
}

function install_golang() {
    cd ~/Downloads
    wget 'https://go.dev/dl/go1.22.1.linux-amd64.tar.gz'
    sudo tar -C ~/.local/bin -xzf '1.22.1.linux-amd64.tar.gz'
    chmod u+x ~/.local/bin/go
}

function install_lazygit() {
    go install github.com/jesseduffield/lazygit@latest
}

# Prompt confirmation to begin the installation
echo "Post installation for your system is about to begin."
read -n 1 -r -s -p "Press any key to continue, or CTRL+C to cancel..."

set -e # Exit immediately if a command fails.
# The line below does not work
# set -y # Unset variables and parameters fail when used.
set -x # Echo commands to make debugging easier.
install_essentials
install_rust
install_alacritty
install_window_manager
install_haskell
install_discord
install_golang
install_lazygit

set +x

# Message to install alacritty
echo "To install alacritty, open a new terminal and run the following command:"
echo "~/.cargo/bin/cargo install alacritty"
echo ""

# Prompt for reboot
echo "Post installation successfully completed!"
echo "It's recommended to reboot with 'systemctl reboot'"

