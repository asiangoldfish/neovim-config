

## Configurations

Install [GNU Stow](https://www.gnu.org/software/stow/) and Git
```
apt install stow git
```

Clone the directory to your local machine
```
git clone https://github.com/asiangoldfish/neovim-config.git $HOME/dotfiles
```

Stow the dotfiles to your home directory.
<b>NB!</b> Stow refuses to stow files if they conflict with existing ones.
Either rename your existing dotfiles or scripts, or delete them.
```
cd dotfiles/packages
stow --dotfiles --target="$HOME" *
```
