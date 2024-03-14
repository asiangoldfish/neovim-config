# Post Installations
If you have a newly installed system, you can quickly get up to speed using and
use my configurations.

**Disclaimer:** My dotfiles are constantly changing. As a consequence, breaking
changes *will* occur. Use the instructions and scripts at *your own risk*.

## Distributions
- [Debian](#debian)

## Debian
*Updated 10th of March 2024*

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
