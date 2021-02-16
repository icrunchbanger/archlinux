#!/usr/bin/env bash
# Copyright (C) 2021 'Nikola Ilic' icrunchbanger@gmail.com

set -uo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR

mkdir -pv /home/$USER/tmpr && cd /home/$USER/tmpr
mkdir -pv /home/$USER/{Documents/{KDBX,Notes},Downloads,Pictures/{Wallpapers,Screenshots},wdir/{android,ISO},github,tdl/ND,tmpr/keys,opt,tmp,.config,.local/bin}
curl "https://api.github.com/users/icrunchbanger/repos?per_page=1000" | grep -o 'https://github.com[^"]*.git'| xargs -L1 git clone
mv *-scripts/* /home/$USER/.local/bin
mv dotfiles/.[!.]* /home/$USER
mv dotfiles/* /home/$USER/.config

echo "exec i3"  > /home/$USER/.xinitrc

yes | ssh-keygen -o -a 100 -t ed25519 -f /home/$USER/.ssh/id_ed25519 -C "keys@ilic.io"
yes | ssh-keygen -t rsa -b 4096 -f /home/$USER/.ssh/id_rsa -C "keys@ilic.io"

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


if (dialog --title "GIT Private Repo" --yesno "This part of the script clones private repo! PREPARE the hardware key! Choose 'NO' if you are not aware of such a repo! " 0 0)

  then

git_user=$(dialog --stdout --passwordbox "Enter GIT username" 0 0) || exit 1
git_url=$(dialog --stdout --passwordbox "Enter GIT URL" 0 0) || exit 1
git_repo=$(dialog --stdout --passwordbox "Enter GIT repo name" 0 0) || exit 1
git_repo_cr_pass=$(dialog --stdout --passwordbox "Enter GIT archive pass" 0 0) || exit 1


sudo mount /dev/disk/by-uuid/a1634b55-d91d-4a61-aaf9-f898c68a75af keys
git clone https://"$git_user":$(cat keys/auth.key)@"$git_url"/"$git_user"/"$git_repo".git

sudo umount keys
for file in private/*.zip
  do
    7z x "$file" -o/home/$USER/ -p"$git_repo_cr_pass"
  done
   fi

rm -rf /home/$USER/{tmpr,packages.sh,postinstall.sh}

exit 0

