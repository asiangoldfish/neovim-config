#!/usr/bin/env bash

################################################################################
# Update log
# Time format: DD-MM-YYYY
#
# - 31.12.2024: Install Spacemacs - an Emacs distribution
# - 12.11.2024: Install firefox, discord, alacritty, neovim, youtube-music
#               and Cisco Anyconnect vpn.
# - 21.02.2025: Add support for configuration file to enable selectively
#               add or disable features, or set values.
# - 11.06.2025: Overhaul script. Packages are now listed in arrays.
################################################################################
REPOS_DIR="$HOME/repos"
if [ ! -d "$REPOS_DIR" ]; then
    mkdir -p "$REPOS_DIR"
fi

LOGFILE="$HOME/arch-postinstall.log"
# TODO: Take into account that the script is executed in an arbitrary place
# in the system or the script is a symlink.
CONFIG_FILE="./arch_config.sh"

# Update system
sudo pacman -Syyu --noconfirm

## Log something to the logfile
## Syntax - Let's log `Hello world`:
##      log "Hello world"
function log() {
    printf "[%s] $1\n" "$(date +"%D %T")" >> "$LOGFILE"
}

## Packages to install
pkgs=(
    git
    base-devel

    # Social media
    discord

    # Media
    vlc

    # Haskell
    ghc
    stack
    cabal-install

    # Fonts
    ttf-jetbrains-mono-nerd
    ttf-ubuntu-font-family
    ttf-fira-code
    adobe-source-code-pro-fonts
)

## AUR packages
aur_pkgs=(
    firefox
    alacritty
    neovim
    youtube-music
)

## To define custom functions, for example to build and install from source,
## define the functions and export them with `exported_pkgs`.
function install_yay() {
    if ! command -v "yay" > /dev/null; then
        # Install yay, the AUR helper
        cd "$REPOS_DIR"
        sudo pacman -S --needed git base-devel
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si
    fi
}

# Install VPN clients
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

# 31.12.2024: This function installs Spacemacs - a preconfigured Emacs.
#             Installation instructions from
#             https://wiki.archlinux.org/title/Spacemacs.
function install_emacs() {
    echo "Installing Spacemacs..."
    sudo pacman -S --noconfirm emacs-wayland
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

exported_pkgs=(
    install_yay
    install_vpn
    install_emacs
)

sudo pacman -S --noconfirm "${pkgs[@]}"
yay -S --noconfirm "${pkgs[@]}"

# Install custom defined packages
for pkg in "${exported_pkgs[@]}"; do
    "$pkg" || exit 1
done

echo "Successfully installed all packages!"

