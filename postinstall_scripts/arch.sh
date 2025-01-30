#!/usr/bin/env bash

################################################################################
# Update log
# Time format: DD-MM-YYYY
#
# - 31.12.2024: Install Spacemacs - an Emacs distribution
# - 12.11.2024: Install firefox, discord, alacritty, neovim, youtube-music
#               and Cisco Anyconnect vpn.
################################################################################
REPOS_DIR="$HOME/repos"
mkdir -p "$REPOS_DIR"

LOGFILE="$HOME/arch-postinstall.log"

# Update system
sudo pacman -Syyu --noconfirm

## Log something to the logfile
## Syntax - Let's log `Hello world`:
##      log "Hello world"
function log() {
    printf "[%s] $1\n" "$(date +"%D %T")" >> "$LOGFILE"
}

## All essential packages are installed here. This includes:
## - AUR helper
## - web browser
## - terminal
## - terminal-based text editor
function install_essentials() {
    if ! command -v "yay" > /dev/null; then
        # Install yay, the AUR helper
        cd "$REPOS_DIR"
        sudo pacman -S --needed git base-devel
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si
    fi

    # Web browser
    sudo pacman -S firefox --noconfirm

    # Terminal, text editor
    yay -S --noconfirm alacritty neovim
}

## Install social platforms for chatting and more.
function install_social_platforms() {
    sudo pacman -S discord --noconfirm
}

## Install music and media players
function install_media() {
    sudo pacman -S vlc --noconfirm
    yay -S --noconfirm youtube-music
}

## Install VPN clients
function install_vpn() {
    if [ -f "/opt/cisco/secureclient/bin/vpnui" ]; then
        return
    fi

    local url='https://vpn1.ntnu.no/cisco-secure-client-linux64-5.1.4.74-core-vpn-webdeploy-k9.sh'

    cd "$REPOS_DIR"
    wget "$url" 1> "$LOGFILE"
    if [ -f "$url" ]; then
        bash 'cisco-secure-client-linux64-5.1.4.74-core-vpn-webdeploy-k9.sh'
    else
        log "Failed to install Cisco VPN"
    fi
}

## Install system-wide fonts
function install_fonts() {
    sudo pacman -S --noconfirm ttf-jetbrains-mono-nerd \
                               ttf-ubuntu-font-family \
                               ttf-fira-code \
                               adobe-source-code-pro-fonts
}

## 31.12.2024: This function installs Spacemacs - a preconfigured Emacs.
##             Installation instructions from
##             https://wiki.archlinux.org/title/Spacemacs.
function install_emacs() {
    echo "Installing Spacemacs..."
    sudo pacman -S --noconfirm emacs
    mv ~/.emacs.d ~/.emacs.d.bak && mv ~/.emacs ~/.emacs.bak
    
    git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d || {
        echo "Failed to install Spacemacs"
        return
    }

    # Spacemacs uses adobe-source-code-pro-fonts package for its font. This
    # should already be installed in function install_fonts.

    ( systemctl --user enable emacs && systemctl --user start emacs ) || {
        echo "Failed to install Spacemacs"
        return
    }
    
    echo "Spacemacs successfully installed. Please run Emacs to configure it "
    echo "for the first time."
}

function install_programming_languages() {
    sudo pacman -S --noconfirm ghc stack cabal-install
}

## You can opt-out on installing packages by commenting out the below functions
install_essentials
install_programming_languages
#install_vpn
install_social_platforms    # discord
install_media               # vlc, youtube-music
install_fonts
install_emacs

echo "Successfully installed all packages!"

