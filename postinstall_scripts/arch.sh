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

function log() {
    printf "[%s] $1\n" "$(date +"%D %T")" >> "$LOGFILE"
}

function install_essentials() {
    # Install yay, the AUR helper
    cd "$REPOS_DIR"
    sudo pacman -S --needed git base-devel
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si

    sudo pacman -S firefox discord

    yay -S --noconfirm alacritty neovim youtube-music
}

function vpn() {
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
