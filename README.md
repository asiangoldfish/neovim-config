# Configs

The (poorly named) <i>neovim-config</i> project is a collection of my personal
dotfiles and scripts. It's designed to be used by tools like
[GNU Stow](https://www.gnu.org/software/stow/).

## Compabilitity
This project's dotfiles and scripts are intended for \*NIX systems. Some
programs are however crossplatform, like [Neovim](.config/nvim) and
[Lazygit](.config/lazygit). To use these configurations on unsupported
platforms, they must be manually downloaded and moved to the designated
locations. There may be dotfiles management systems that I am not aware
of that support this project's directory structure.

## Deploy Configuration
Install [GNU Stow](https://www.gnu.org/software/stow/) and Git
```
apt install stow git
```

Clone the directory to your local machine
```
git clone https://github.com/asiangoldfish/neovim-config.git
```

Stow the dotfiles to your home directory.
<b>NB!</b> Stow refuses to stow files if they conflict with existing ones.
Either rename your existing dotfiles or scripts, or delete them.
```
cd neovim-config
stow .
```

## Installation
Debian:
```sh
sudo apt update && sudo apt full-upgrade -y
sudo apt install -y curl
curl https://raw.githubusercontent.com/asiangoldfish/neovim-config/main/install_scripts/debian.sh | bash
```
