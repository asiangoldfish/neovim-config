# Post Installations
If you have a newly installed system, you can quickly get up to speed using and
use my configurations.

**Disclaimer:** My dotfiles are constantly changing. As a consequence, breaking
changes *will* occur. Use the instructions and scripts at *your own risk*.

A part of the post installations are installing this dotfiles repository to your
system. Therefore, you don't need to install it separately to your system.

**Warning:** Any files that exist in your home directory and are included in
this repository, will be erased and lost. They will not be backed up, because
the script is meant for newly installed systems only.

## Distributions
- [Debian](#debian)

## Debian
*Updated 15th of March 2024*

There are a couple of steps involved in setting up a new Debian system. They are
broken down in the following sections:
1. [Installing Debian](#installing-debian)
2. [Adding sudoer](#adding-sudoer)
3. [Post Installation Script](#post-installation-script)

### Installing Debian
To install Debian:
1. Download the .iso from the
    [official website](https://www.debian.org/download).
2. Install Debian on your system, in a virtual machine, or by other means.
3. When asked to select a dekstop environment, please select **XFCE**. It
   contains convinient and minimal packages for graphical utilities.

### Adding sudoer
By default, Debian will not add your account to the sudoers file. This can be
performed as follows:
1. Switch to super user and your user to the `sudo` group.

    ```sh
    su
    sudo usermod -aG sudo YOUR_USERNAME
    ```

2. To activate the changes, log out or reboot the system. To log out, while
   logged in as the super user, do the following command:

   ```sh
   pkill -u YOUR_USERNAME
   ```


### Post Installation Script
I have provided a [post installation script](../postinstall_scripts/debian.sh)
that will set up almost the rest of the system. There is minimal manual
intervention required, as I have not found out how to automate them

1. Update and full-upgrade the system
    ```sh
    sudo apt update && sudo apt full-upgrade -y
    ```
2. Install curl
    ```
    sudo apt install -y curl
    ```

3. Run the installer
    ```
    curl https://raw.githubusercontent.com/asiangoldfish/neovim-config/main/postinstall_scripts/debian.sh | bash
    ```

4. When prompted by *rustup*, press Enter to confirm the default options. Afterward, the installer will continue autonomously until it finishes.

4. Install Alacritty (this is required as per my i3 configuration)
    - Open a new terminal. This ensures that you're using the up-to-date rustc
        version.
    - Install Alacritty:
        ```
        cargo install alacritty
        ```

5. Reboot the system. Upon logging in, change to i3.

## Arch Linux
*Updated 20th of June 2025*

It is recommended to install a newer version of the Arch live ISO. Using the script *archinstall* is recommended to use. I personally use SwayWM, and my personal configurations are therefore targetting this specific window manager. You are free to choose your own preferred desktop environment. If you want to use my configuration, select `Sway` once you are in the *profile* dialog in *archinstall*. Also, remember to create a root user and your own daily-driver user.

Upon completing the installation, remove the USB flash drive select to chroot into the new system. This is where the interesting bit begins.

First, we are changing to the new user and cloning this repository to the new system.

```sh
# Change to the new user
su MY_USERNAME

# Install prerequisites.
sudo pacman -S git stow
git clone https://github.com/asiangoldfish/neovim-config.git "$HOME/dotfiles"
cd dotfiles

# Creat symlinks. Forcefully overwrite existing files.
stow --adopt *
git restore .
```

What this will do is cloning the repository to *dotfiles*. To reconfigure your user, like changing some dotfiles, you can simply edit files here. The last line, `stow .`, creates a symlink of the repository to your user account. This is the dotfile manager. To manage your dotfiles, use the new command `dotfiles.sh` directly from your terminal.

Once the dotfiles are configured, it's time to install the rest of the system.

```
bash postinstall_scripts/arch.sh
```

This command installs required packages for my own configuration and day-to-day use cases. They are focused on general-purpose programming, particularly in systems programming.

