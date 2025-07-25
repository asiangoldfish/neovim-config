sudo pacman -S qemu virt-manager dnsmasq virt-viewer vde2 bridge-utils libguestfs

sudo systemctl enable --now libvirtd
sudo usermod -aG libvirt $USER
sudo systemctl restart libvirtd
# sudo modprobe kvm
# sudo usermod -aG kvm $USER
