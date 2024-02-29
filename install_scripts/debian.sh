LOG='~/postinstall_log.txt'

echo "Installing nala..."
# Install APT frontend
sudo apt install nala -y 

echo "Installing vim, git, curl, stow, fish, yad, sxhkd..."
# Install base applications
sudo nala install vim git curl stow fish yad sxhkd -y

echo "Installing rust..."
# Install essential: Alacritty
sudo nala install -y cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3
curl https://sh.rustup.rs -sSf | sh -s -- -y 2> "$LOG"

sudo nala install -y cargo

echo "Installing alacritty..."
# Get updated rust version
~/.cargo/bin/rustup override set stable
~/.cargo/bin/rustup update stable¨
alias rustc='~/.cargo/bin/rustc'
~/.cargo/bin/cargo install alacritty 2> "$LOG"

# i3
echo "Installing i3..."
sudo nala install -y i3 --no-install-recommends


echo "Cloning neovim-config..."
git clone --recurse-submodules https://github.com/asiangoldfish/neovim-config.git ~/config-stow
cd ~/config-stow

# Overwrite existing files
echo "Deploying dotfiles from ~/config-stow"
stow --adopt .
git restore .
