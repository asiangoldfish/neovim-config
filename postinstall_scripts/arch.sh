#!/usr/bin/env bash

################################################################################
# Update log
# Time format: DD-MM-YYYY
#
# - 11.06.2025: Overhaul script. Packages are now listed in arrays.
# - 20.06.2025: Yet another overhaul: Separate packages and custom functions
################################################################################
echo "Launching the Arch Linux post-installation script..."

REPOS_DIR="$HOME/src"
if [ ! -d "$REPOS_DIR" ]; then
    mkdir -p "$REPOS_DIR"
fi

LOGFILE="$(mktemp /tmp/scope_log.XXXXXX)"
script_dir="$(dirname "$0")"
LAST_STEPS="$HOME/last_steps.sh"
PROFILE=""
PROFILE_PATH=""
PROFILE_DIR="./arch/profiles"

# Profile selector - A profile is the user's working environment, like KDE or
#                    Hyprland
echo "Launching profile selector..."
if ! command -v gum > /dev/null; then
    echo "Command gum is not found, but is required. Installing..."
    sudo pacman -Sy gum --noconfirm || { echo "Failed to install gum"; exit 1; }
fi

if [ ! -d "$PROFILE_DIR" ]; then
    echo "Failed to find profile dir"
    exit 1
fi

# Collect .conf files and strip extensions
mapfile -t profiles < <(find "$PROFILE_DIR" -maxdepth 1 -type f -name "*.conf" -exec basename {} .conf \; | sort)

# Check if any profiles exist
if [[ ${#profiles[@]} -eq 0 ]]; then
    echo "No .conf files found in $PROFILE_DIR"
    exit 1
fi

echo "Select a profile to install:"
PROFILE=$(printf "%s\n" "${profiles[@]}" | gum choose --limit=1)

echo
echo "✅ You selected profile: $PROFILE"

PROFILE_PATH="$PROFILE_DIR/$PROFILE.conf"
source "$PROFILE_PATH"

# Get all packages to install
source "$script_dir/arch/arch_config.conf"

# Install yay, the AUR helper
if ! command -v "yay" > /dev/null; then
    ( cd "$REPOS_DIR"
    sudo pacman -S --needed --noconfirm git base-devel
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si )
else
    echo "Yay already exists. Skipping..."
fi

# Concatenate base packages with desktop dependent packages
PKGS+=( "${profile_packages[@]}" )

echo "${PKGS[@]}"
exit 1

yay --needed -S --needed --noconfirm "${PKGS[@]}"

find "$script_dir/arch" -type f -name "*.sh" | while read -r file; do
    ( source "$file" )
done

echo "Successfully installed all packages!"
echo "Symlinking dotfiles..."

cd "$script_dir/../packages"
stow --adopt --dotfiles --target="$HOME" *
git restore ..
stow --dotfiles --target="$HOME" *

echo "Arch installation last steps completed!" >> "$LAST_STEPS"
