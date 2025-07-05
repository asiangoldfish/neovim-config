echo "Installing bluetooth..."
sudo pacman -S --needed bluez blueman
sudo systemctl enable --now bluetooth
