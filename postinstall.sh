#!/usr/bin/env bash
# Copyright (C) 2021 'Nikola Ilic' icrunchbanger@gmail.com

set -uo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR

mkdir -pv /home/$USER/tmpr && cd /home/$USER/tmpr
mkdir -pv /home/$USER/{Documents/{KDBX,Notes},Downloads,Pictures/{Wallpapers,Screenshots},wdir/{android,ISO},gitlab,tdl/ND,opt,tmp,.config,.icons,.local/bin,.themes}
git clone https://gitlab.com/icrunchbanger/android-scripts
git clone https://gitlab.com/icrunchbanger/dotfiles
git clone https://gitlab.com/icrunchbanger/linux-scripts
git clone https://github.com/BunsenLabs/bunsen-themes
git clone https://github.com/snwh/paper-icon-theme
mv *-scripts/* /home/$USER/.local/bin
mv bunsen-themes/themes/Bunsen-He-flatish /home/$USER/.themes/BHF
mv paper-icon-theme/Paper /home/$USER/.icons/Paper
mv dotfiles/.[!.]* /home/$USER
mv dotfiles/* /home/$USER/.config

echo "exec i3"  > /home/$USER/.xinitrc

sudo sed -i 's/#unix_sock_rw_perms = "0770"/unix_sock_rw_perms = "0770"/g' /etc/libvirt/libvirtd.conf
sudo sed -i 's/#unix_sock_group = "libvirt"/unix_sock_group = "libvirt"/g' /etc/libvirt/libvirtd.conf
sudo usermod -a -G libvirt $(whoami)
sudo modprobe -r kvm_amd
sudo modprobe kvm_amd nested=1
echo "options kvm-amd nested=1" | sudo tee /etc/modprobe.d/kvm-amd.conf
sudo systemctl --now enable NetworkManager
sudo systemctl --now enable cronie
sudo systemctl --now enable libvirtd
sudo udevadm control --reload-rules
sudo touch /etc/crontab
sudo ntpd -qg

rm -rf /home/$USER/{tmpr,packages.sh,postinstall.sh}
exit 0

