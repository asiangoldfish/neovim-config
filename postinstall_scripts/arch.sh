#!/usr/bin/env bash

################################################################################
# Update log
# Time format: DD-MM-YYYY
#
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
                               ttf-ubuntu-font-family
}

## You can opt-out on installing packages by commenting out the below functions
install_essentials
#install_vpn
install_social_platforms    # discord
install_media               # vlc, youtube-music
install_fonts

echo "Successfully installed all packages!"

