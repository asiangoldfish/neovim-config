## 31.12.2024: This function installs Spacemacs - a preconfigured Emacs.
##             Installation instructions from
##             https://wiki.archlinux.org/title/Spacemacs.

echo "Installing Spacemacs..."
sudo pacman --needed -S --noconfirm emacs-wayland
mv ~/.emacs.d ~/.emacs.d.bak && mv ~/.emacs ~/.emacs.bak

git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d || {
    echo "Failed to install Spacemacs"
    return
}

# Spacemacs uses adobe-source-code-pro-fonts package for its font. This
# should already be installed in function install_fonts.

# In the live ISO, the below command will fail.
# TODO create an automated way to execute this command on the first time booting up
# if this failed.
( systemctl --user enable emacs > /dev/null && systemctl --user start emacs ) || {
    echo 'systemctl --user enable emacs && systemctl --user start emacs' >> "$LAST_STEPS"
}

echo "Spacemacs successfully installed. Please run Emacs to configure it "
echo "for the first time."
