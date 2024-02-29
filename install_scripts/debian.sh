# Install APT frontend
sudo apt install nala -y

# Install base applications
sudo nala install vim git curl stow fish yad sxhkd -y

# Install essential: Alacritty
sudo nala install -y cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3
curl https://sh.rustup.rs -sSf | sh -s -- -y

# Source rust environment to get rustup to PATH
. "$HOME/.cargo/env"

# Get updated rust version
rustup override set stable
rustup update stable
cargo install alacritty

# i3
sudo nala install -y i3 --no-install-recommends


git clone --recurse-submodules https://github.com/asiangoldfish/neovim-config.git ~/config-stow
cd ~/config-stow

# Overwrite existing files
stow --adopt .
git restore .
