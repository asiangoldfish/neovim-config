#!/usr/bin/env bash

set -e # Exit immediately if a command fails.

# The line below does not work
# set -y # Unset variables and parameters fail when used.

set -x # Echo commands to make debugging easier.

function install_essentials() {
    # apt frontend
    echo "Installing nala..."
    sudo apt install nala -y 

    echo "Installing essentials..."
    sudo nala -y install \
         vim git curl stow fish yad sxhkd cmake emacs feh picom ripgrep \

         # For latex support...
	    # Look https://emacs.stackexchange.com/a/73197 for more info on
	    # rendering Latex on emacs
         latex dvipng texlive-latex-extra \

	     # Fonts
    	 fonts-cantarell fonts-jetbrains-mono \

        # Working with documents
        pandoc
}

function install_rust() {
    echo "Installing rust..."
    curl https://sh.rustup.rs -sSf | sh -s -- -y
}

function install_alacritty() {
    # Install essential: Alacritty
    sudo nala install -y  \
        pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev \
        libxkbcommon-dev python3
    sudo nala install -y cargo

    echo "Installing alacritty..."
    # Get updated rust version
    # TODO: Fix this part. This tends to break for some reason (Incorrect rust version)
    sleep 1
    ~/.cargo/bin/rustup override set stable
    ~/.cargo/bin/rustup update stable¨
    alias rustc='~/.cargo/bin/rustc'
    ~/.cargo/bin/cargo install alacritty
}

function install_window_manager() {
    # i3
    echo "Installing i3..."
    sudo nala install -y i3 --no-install-recommends
}

function install_dotfiles() {
    echo "Cloning neovim-config..."
    # Edit the URL if to use your own config
    git clone --recurse-submodules https://github.com/asiangoldfish/neovim-config.git ~/config-stow
    cd ~/config-stow

    # Overwrite existing files
    echo "Deploying dotfiles from ~/config-stow"
    stow --adopt .
    git restore .
}

function install_haskell() {
    # Installing Haskell toolchains
    # Source: https://stackoverflow.com/a/72953383
    sudo nala install -y build-essential curl libffi-dev libffi8ubuntu1 libgmp-dev libgmp10 libncurses-dev libncurses5 libtinfo5 &&
    curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | BOOTSTRAP_HASKELL_NONINTERACTIVE=1 BOOTSTRAP_HASKELL_GHC_VERSION=latest BOOTSTRAP_HASKELL_CABAL_VERSION=latest BOOTSTRAP_HASKELL_INSTALL_STACK=1 BOOTSTRAP_HASKELL_INSTALL_HLS=1 BOOTSTRAP_HASKELL_ADJUST_BASHRC=P sh
}

install_essentials
install_rust
install_alacritty
install_window_manager
install_haskell

# Prompt for reboot
read -r -p "Post installation successfully completed!
It's recommended to reboot. Continue? [Y/n] " response
case "$response" in
    [nN][oO]) 
        break
        ;;
    *)
        systemctl reboot
esac
