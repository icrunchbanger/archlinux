#!/usr/bin/env bash
# Copyright (C) 2021 'Nikola Ilic' icrunchbanger@gmail.com

set -uo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR

pacman -Sy --noconfirm pacman-contrib dialog

echo "Updating mirror list"
reflector --verbose --latest 5 --country Germany --age 24 --protocol https --sort rate --save /etc/pacman.d/mirrorlist


hostname=$(dialog --stdout --inputbox "Enter hostname" 0 0) || exit 1
clear
: ${hostname:?"hostname cannot be empty"}

user=$(dialog --stdout --inputbox "Enter admin username" 0 0) || exit 1
clear
: ${user:?"user cannot be empty"}

password=$(dialog --stdout --passwordbox "Enter admin password" 0 0) || exit 1
clear
: ${password:?"password cannot be empty"}
password2=$(dialog --stdout --passwordbox "Enter admin password again" 0 0) || exit 1
clear
[[ "$password" == "$password2" ]] || ( echo "Passwords did not match"; exit 1; )


luks_password=$(dialog --stdout --passwordbox "Enter disk encryption password" 0 0) || exit 1
clear
: ${luks_password:?"password cannot be empty"}
luks_password2=$(dialog --stdout --passwordbox "Enter disk encryption password again" 0 0) || exit 1
clear
[[ "$luks_password" == "$luks_password2" ]] || ( echo "Passwords did not match"; exit 1; )


devicelist=$(lsblk -dplnx size -o name,size | grep -Ev "boot|rpmb|loop" | tac)
device=$(dialog --stdout --menu "Select installation disk" 0 0 0 ${devicelist}) || exit 1
mapper="/dev/mapper"

sfdisk --delete -f "${device}"

sgdisk -n 0:0:+1G -t 0:ef00 "${device}"
sgdisk -n 0:0:0 -t 0:8300 "${device}"
echo "$luks_password" | cryptsetup luksFormat "${device}"p2
echo "$luks_password" | cryptsetup open --type luks "${device}"p2 cryptroot

mkfs.fat -F32 -n linuxEFI "${device}"p1
mkfs.btrfs -L ArchLinux "${mapper}"/cryptroot

mount -o compress=zstd,noatime "${mapper}"/cryptroot /mnt
btrfs subvol create /mnt/@
btrfs subvol create /mnt/@home
btrfs subvol create /mnt/@swap

mkdir /mnt/snapshots
btrfs subvol create /mnt/snapshots/@
btrfs subvol create /mnt/snapshots/@home

umount /mnt
mount -o compress=zstd,noatime,subvol=@ "${mapper}"/cryptroot /mnt
mkdir -p /mnt/{boot,home}
mount -o compress=zstd,noatime,subvol=@home "${mapper}"/cryptroot /mnt/home
mount /dev/nvme0n1p1 /mnt/boot

mkdir /mnt/var
btrfs subvol create /mnt/var/cache
btrfs subvol create /mnt/var/log

mkdir -p /mnt/var/lib/{machines}
chattr +C /mnt/var/lib/{machines}

pacstrap /mnt base base-devel linux linux-firmware amd-ucode lvm2 btrfs-progs dosfstools e2fsprogs dhcpcd git vim wget
genfstab -p /mnt >> /mnt/etc/fstab


arch-chroot /mnt /bin/bash <<EOF
rm -f /etc/localtime
ln -s /usr/share/zoneinfo/Europe/Belgrade /etc/localtime
hwclock --systohc --utc
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
locale-gen
locale > /etc/locale.conf
echo "${hostname}" > /mnt/etc/hostname
sed -i 's/^HOOKS.*/HOOKS="base systemd udev autodetect modconf block keyboard sd-encrypt lvm2 filesystems fsck"/' /etc/mkinitcpio.conf
echo "BINARIES=(btrfs)" >> /etc/mkinitcpio.conf
mkinitcpio -p linux
bootctl --path=/boot/ install
cat << LOADER > /boot/loader/loader.conf
default Arch Linux
timeout 0
editor 0
LOADER
cat << initramfs > /boot/loader/entries/arch.conf
title Arch Linux
linux /vmlinuz-linux
initrd  /amd-ucode.img
initrd /initramfs-linux.img
options rd.luks.name=$(blkid -s UUID -o value "${device}"p2)=cryptroot root=/dev/mapper/cryptroot rootflags=subvol=@ rd.luks.options=discard rw
initramfs
sed 's/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/g' /etc/sudoers > /etc/sudoers.new
export EDITOR="cp /etc/sudoers.new"
visudo
rm /etc/sudoers.new
useradd -m -g users -G wheel -s /bin/bash "$user"
echo "$user:$password" | chpasswd
echo "root:$password" | chpasswd
exit
EOF

umount -l /mnt
