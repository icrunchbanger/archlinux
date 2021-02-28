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

mkdir -pv keys

git_user=$(dialog --stdout --passwordbox "GIT username?" 0 0) || exit 1
git_url=$(dialog --stdout --passwordbox "GIT URL Provider?" 0 0) || exit 1
git_repo=$(dialog --stdout --passwordbox "GIT repo name?" 0 0) || exit 1
git_repo_cr_pass=$(dialog --stdout --passwordbox "GIT archive pass?" 0 0) || exit 1


sudo mount /dev/disk/by-uuid/0705c416-eba6-4810-95ff-2af792d2a98d keys
git clone https://"$git_user":$(cat keys/wc.key)@"$git_url"/"$git_user"/"$git_repo".git

mv */*.sh /home/$USER/.local/bin/

sudo umount keys

for file in private/*.zip
  do
    7z x "$file" -o/home/$USER/ -p"$git_repo_cr_pass"
  done
   fi


rm -rf /home/$USER/{tmpr,packages.sh,postinstall.sh}

exit 0
