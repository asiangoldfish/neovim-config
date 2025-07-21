sudo systemctl enable --now libvirtd.socket
sudo usermod -aG libvirt $USER
sudo modprobe kvm
sudo usermod -aG kvm $USER

