#!/usr/bin/env bash

### Essential updates
# Packages that are mostly installed with apt goes here. They do not include
# dependencies, unless necessary to install an essential package.
function install_essentials() {
    # Nala: APT frontend
    if ! command -v nala > /dev/null; then
        echo "Installing nala..."
        sudo apt install nala -y
    fi

    # Essential packages
    if ! command -v vim > /dev/null; then
        echo "Installing essentials..."
        sudo nala install -y \
            vim git curl stow yad sxhkd cmake emacs feh picom ripgrep rofi \
            ranger polybar

            # For latex support...
            # Look https://emacs.stackexchange.com/a/73197 for more info on
            # rendering Latex on emacs
        sudo nala install -y texlive-latex-extra

        # Fonts
        sudo nala install -y fonts-cantarell fonts-jetbrains-mono

        # PDF converters
        sudo nala install -y pandoc

        # Email clients
        sudo nala install -y thunderbird

        # Screenshots
        sudo nala install -y flameshot

        # Bluetooth
        sudo nala install -y blueman

        # Python
        sudo nala install -y libreadline-dev tk-dev

        # Binaries only for the user
        mkdir -p ~/.local/bin

        # File management
        sudo nala install -y fzf

        # Development
        sudo nala install -y meson

        # Ensure gems directory exists to Ruby gems install packages locally
        mkdir -p "$HOME/gems"
    fi

    # Tmux
    if ! command -v tmux > /dev/null; then
        sudo nala install -y tmux
    fi
}

function install_rust() {
    command -v ~/.cargo/bin/rustup > /dev/null && return 0
    echo "Installing rust..."
    RUSTUP_INIT_SKIP_PATH_CHECK=yes curl https://sh.rustup.rs -sSf | sh -s -- 
}

function install_alacritty() {
    command -v ~/.cargo/bin/alacritty > /dev/null && return
    # Install essential: Alacritty
    sudo nala install -y \
        pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev \
        libxkbcommon-dev python3
    sudo nala install -y cargo

 #   echo "Installing alacritty..."
    # Get updated rust version
    # TODO: Fix this part. This tends to break for some reason (Incorrect rust version)
#    sleep 1
  #  ~/.cargo/bin/rustup override set stable
   # ~/.cargo/bin/rustup update stable¨
    #alias rustc='~/.cargo/bin/rustc'
    #~/.cargo/bin/cargo install alacritty
}

function install_i3() {
    command -v i3 > /dev/null && return

    # Some distros have outdated i3. Ubuntu and its derivatives
    # on stable version have very outdated versions of i3. So
    # we just built it ourselves.

    # Get distro name
    source /etc/os-release

    if [ -z "$NAME" ]; then # Empty name. Don't install i3
        return 1
    fi

    echo "Installing i3..."

    if [ "$NAME" == "Debian GNU/Linux" ]; then
        sudo nala install -y i3 --no-install-recommends
    else
        echo "Installing i3 dependencies"
        sudo nala install -y build-essential zlib1g-dev libffi-dev libssl-dev libbz2-dev libreadline-dev libsqlite3-dev liblzma-dev ninja-build meson


        if [ ! -d "$HOME/Downloads" ]; then mkdir "$HOME/Downloads"; fi
        cd "$HOME/Downloads"
        sleep 1
        echo "hi"
        sleep 1
        git clone https://github.com/i3/i3.git > /dev/null
        echo "Exit code i3: $?"
        cd i3
        mkdir -p build
        meson .. || return 1
        ninja || return 1

        # TODO: Post-installation (.application, mv to /usr/i3, ...)
    fi
}

function install_dotfiles() {
    if [ -d "$HOME/dotfiles" ]; then
        return
    fi

    echo "Cloning dotfiles from GitHub..."
    # Edit the URL if to use your own config
    git clone --recurse-submodules https://github.com/asiangoldfish/neovim-config.git ~/dotfiles
    cd ~/dotfiles

    # Overwrite existing files
    echo "Deploying dotfiles from ~/dotfiles"
    stow --adopt .
    git reset
    stow .
}

function install_haskell() {
    command -v ~/.ghcup/bin/ghcup > /dev/null && return
    command -v ghcup > /dev/null && return

    # Installing Haskell toolchains
    # Source: https://stackoverflow.com/a/72953383
    sudo nala install -y build-essential curl libffi-dev libffi8ubuntu1 libgmp-dev libgmp10 libncurses-dev libncurses5 libtinfo5
    curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | BOOTSTRAP_HASKELL_NONINTERACTIVE=1 BOOTSTRAP_HASKELL_GHC_VERSION=latest BOOTSTRAP_HASKELL_CABAL_VERSION=latest BOOTSTRAP_HASKELL_INSTALL_STACK=1 BOOTSTRAP_HASKELL_INSTALL_HLS=1 BOOTSTRAP_HASKELL_ADJUST_BASHRC=P sh
}

function install_discord() {
    command -v discord > /dev/null && return

    mkdir -p ~/Downloads
    cd ~/Downloads
    wget "https://discord.com/api/download?platform=linux&format=deb" -O discord.deb
    sudo nala install -y ./discord.deb
}

function install_golang() {
    command -v go > /dev/null && return
    if [ -d "$HOME/.local/bin/go" ]; then
        return
    fi

    cd ~/Downloads
    wget 'https://go.dev/dl/go1.22.1.linux-amd64.tar.gz'
    sudo tar -C ~/.local/bin -xzf 'go1.22.1.linux-amd64.tar.gz'
}

function install_lazygit() {
    if [ -f "$HOME/go/bin/lazygit" ]; then
        return;
    fi

    go install github.com/jesseduffield/lazygit@latest
}

function install_vscode() {
    command -v code > /dev/null && return

    # Get pgp key
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    sudo install -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/microsoft-archive-keyring.gpg
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

    # Install with apt
    sudo nala update
    sudo nala install -y code
}

function install_neovim() {
    command -v nvim > /dev/null && return

    # Build instructions from 
    # https://github.com/neovim/neovim/blob/master/BUILD.md
    sudo nala install ninja-build gettext cmake unzip curl build-essential
    
    if [ ! -d "$HOME/Downloads" ]; then
        mkdir "$HOME/Downloads"
    fi
    cd ~/Downloads
    git clone https://github.com/neovim/neovim
    cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo
    cd build && cpack -G DEB && sudo dpkg -i nvim-linux64.deb
}

function install_gtk3_dev() {
    if [ ! -z "$(nala list -i | grep python3-gi)" ]; then
        return
    fi

    sudo nala install -y python3-gi
}

function install_dotfiles_config() {
    sudo nala install
    git clone https://github.com/asiangoldfish/neovim-config.git $HOME/dotfiles
    cd ~/dotfiles
    stow --adopt
    git reset
    stow .
}

# Ziglang version 0.13.0
function install_ziglang() {
    # Skip the installation if zig is already installed
    if [ -d "$HOME/.zig" ] && [ -f "$HOME/.zig/zig" ]; then
        return 0
    fi

    # Install Ziglang
    if [ -z "$HOME" ]; then
        HOME="$(echo ~)"
    fi

    echo "Installing Ziglang version 0.13.0..."
    mkdir -p ~/Downloads
    cd ~/Downloads
    wget 'https://ziglang.org/builds/zig-linux-x86_64-0.14.0-dev.1200+104553714.tar.xz' -O zig-archive
    mkdir -p "$HOME/.zig"
    tar xf 'zig-archive' --directory="$HOME/.zig"

    ## Remove unecessary directory
    cd "$HOME/.zig"
    mv "zig-linux-x86_64-0.14.0-dev.1200+104553714"/* .
    rmdir "zig-linux-x86_64-0.14.0-dev.1200+104553714"

    return 0
}

function install_nerdfonts() {
    if [ -f "$HOME/.local/share/fonts/UbuntuNerdFontPropo-BoldItalic.ttf" ]
    then
        return 0
    fi

    declare -a fonts=(
        BitstreamVeraSansMono
        CodeNewRoman
        DroidSansMono
        FiraCode
        FiraMono
        Go-Mono
        Hack
        Hermit
        JetBrainsMono
        Meslo
        Noto
        Overpass
        ProggyClean
        RobotoMono
        SourceCodePro
        SpaceMono
        Ubuntu
        UbuntuMono
    )

    fonts_dir="${HOME}/.local/share/fonts"

    if [[ ! -d "$fonts_dir" ]]; then
        mkdir -p "$fonts_dir"
    fi

    for font in "${fonts[@]}"; do
        zip_file="${font}.zip"
        download_url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${zip_file}"
        echo "Downloading $download_url"
        wget "$download_url"
        yes "n" | unzip "$zip_file" -d "$fonts_dir"
        rm "$zip_file"
    done

    find "$fonts_dir" -name '*Windows Compatible*' -delete

    fc-cache -fv
}


# Prompt confirmation to begin the installation
echo "Post installation for your system is about to begin."
read -n 1 -r -s -p "Press any key to continue, or CTRL+C to cancel..."

# The line below does not work
# set -y # Unset variables and parameters fail when used.
# set -x # Echo commands to make debugging easier.

rust_success="$(install_rust)"
install_essentials
alacritty_success="$(install_alacritty)"
i3_success="0" #  "$(install_i3)"
haskell_success="$(install_haskell)"
discord_success="$(install_discord)"
golang_success="$(install_golang)"
ziglang_success="$(install_ziglang)"

# Path needs to include go binary directory before continuing with installing lazygit
export GOROOT="$HOME/.local/bin/go"
export PATH="$PATH:$GOROOT/bin"

lazygit_success="$(install_lazygit)"
vscode_success="$(install_vscode)"
neovim_success="$(install_neovim)"
gtkdev_success="$(install_gtk3_dev)"

dotfiles_success="$(install_dotfiles)"
nerdfonts_success="$(install_nerdfonts)"

# set +x

# Print errors if any packages failed to install
## Rust
if [[ "$rust_success" -gt 0 ]]; then echo "Rust failed to install"; fi

## Alacritty
if [[ "$alacritty_success" -gt 0 ]]; then
    echo "Alacritty failed to install"
    echo ""
    echo "To install alacritty, open a new terminal and run the following command:"
    echo "~/.cargo/bin/cargo install alacritty"
fi

## i3
if [[ "$i3_success" -gt 0 ]]; then echo "i3wm failed to install"; fi

## Haskell
if [[ "$haskell_success" -gt 0 ]]; then echo "Haskell failed to install"; fi

## Discord
if [[ "$discord_success" -gt 0 ]]; then echo "Discord failed to install"; fi

## Golang
if [[ "$golang_success" -gt 0 ]]; then echo "Golang failed to install"; fi

## Zig
if [[ "$ziglang_success" -gt 0 ]]; then echo "Ziglang failed to install"; fi

## Lazygit
if [[ "$lazygit_success" -gt 0 ]]; then echo "Lazygit failed to install"; fi

## Visual Studio Code
if [[ "$vscode_success" -gt 0 ]]; then
    echo "Visual Studio Code failed to install"
fi

## Neovim
if [[ "$neovim_success" -gt 0 ]]; then echo "Neovim failed to install"; fi

## GTK Dev Kit
if [[ "$gtkdev_success" -gt 0 ]]; then echo "GTK Dev Kit failed to install"; fi

## Dotfiles
if [[ "$dotfiles_success" -gt 0 ]]; then echo "Dotfiles failed to employ"; fi

## Nerd fonts
if [[ "$nerdfonts_success" -gt 0 ]]; then echo "Nerd Fonts failed to install"; fi


# Prompt for reboot
echo ""
echo "Post installation successfully completed!"
echo "It's recommended to reboot with 'systemctl reboot'"
