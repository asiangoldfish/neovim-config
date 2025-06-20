#!/usr/bin/env bash

################################################################################
# Update log
# Time format: DD-MM-YYYY
#
# - 11.06.2025: Overhaul script. Packages are now listed in arrays.
# - 20.06.2025: Yet another overhaul: Separate packages and custom functions
################################################################################
REPOS_DIR="$HOME/src"
if [ ! -d "$REPOS_DIR" ]; then
    mkdir -p "$REPOS_DIR"
fi

LOGFILE="$(mktemp /tmp/scope_log.XXXXXX)"
script_dir="$(dirname "$0")"

LAST_STEPS="$HOME/last_steps.sh"

# Get all packages to install
source "$script_dir/arch/arch_config.conf"

# Install yay, the AUR helper
if ! command -v "yay" > /dev/null; then
    cd "$REPOS_DIR"
    sudo pacman -S --needed git base-devel
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
else
    echo "Yay already exists. Skipping..."
fi

yay -S --noconfirm "${PKGS[@]}"

find "$script_dir/arch" -type f -name "*.sh" | while read -r file; do
    ( source "$file" )
done

echo "Successfully installed all packages!"

echo "Arch installation last steps completed!" >> "$LAST_STEPS"