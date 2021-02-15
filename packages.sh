#!/usr/bin/env bash
# Copyright (C) 2021 'Nikola Ilic' icrunchbanger@gmail.com

set -uo pipefail
trap 's=$?; echo "$0: Error on line "$LINENO": $BASH_COMMAND"; exit $s' ERR

clear

echo "Updating repos and installing AUR helper"

sudo pacman -Syu

if [[ ! $(command -v pikaur) ]]
then
    echo "Installing Pikaur"
    cd /tmp
    wget https://aur.archlinux.org/cgit/aur.git/snapshot/pikaur.tar.gz
    tar zxvf pikaur.tar.gz
    cd pikaur
    makepkg -si --noconfirm
fi

echo "Installing basic X packages"
pikaur -S --noconfirm --needed xorg-server
pikaur -S --noconfirm --needed xorg-xinit
pikaur -S --noconfirm --needed xorg-xrandr
pikaur -S --noconfirm --needed xorg-xrdb
pikaur -S --noconfirm --needed xorg-xmodmap
pikaur -S --noconfirm --needed xf86-input-libinput
pikaur -S --noconfirm --needed xf86-video-amdgpu

echo "Installing sound packages"
pikaur -S --noconfirm --needed alsa-utils
pikaur -S --noconfirm --needed pulseaudio-alsa
pikaur -S --noconfirm --needed pavucontrol

echo "Installing fonts"
pikaur -S --noconfirm --needed inter-font
pikaur -S --noconfirm --needed terminus-font
pikaur -S --noconfirm --needed ttf-bitstream-vera
pikaur -S --noconfirm --needed ttf-dejavu
pikaur -S --noconfirm --needed ttf-font-awesome

echo "Installing network tools"
pikaur -S --noconfirm --needed networkmanager
pikaur -S --noconfirm --needed network-manager-applet

echo "Installing basic tools"
pikaur -S --noconfirm --needed bc
pikaur -S --noconfirm --needed upower
pikaur -S --noconfirm --needed dmidecode
pikaur -S --noconfirm --needed colordiff
pikaur -S --noconfirm --needed cpio
pikaur -S --noconfirm --needed cronie
pikaur -S --noconfirm --needed dkms
pikaur -S --noconfirm --needed file-roller
pikaur -S --noconfirm --needed fuse
pikaur -S --noconfirm --needed openbsd-netcat
pikaur -S --noconfirm --needed gvfs
pikaur -S --noconfirm --needed gvfs-mtp
pikaur -S --noconfirm --needed iftop
pikaur -S --noconfirm --needed imagemagick
pikaur -S --noconfirm --needed iotop
pikaur -S --noconfirm --needed libmtp
pikaur -S --noconfirm --needed lsof
pikaur -S --noconfirm --needed lzop
pikaur -S --noconfirm --needed mtpfs
pikaur -S --noconfirm --needed mtr
pikaur -S --noconfirm --needed ncftp
pikaur -S --noconfirm --needed ntp
pikaur -S --noconfirm --needed openssh
pikaur -S --noconfirm --needed p7zip
pikaur -S --noconfirm --needed polkit-gnome
pikaur -S --noconfirm --needed rsync
pikaur -S --noconfirm --needed screen
pikaur -S --noconfirm --needed squashfs-tools
pikaur -S --noconfirm --needed strace
pikaur -S --noconfirm --needed the_silver_searcher
pikaur -S --noconfirm --needed time
pikaur -S --noconfirm --needed tree
pikaur -S --noconfirm --needed unrar
pikaur -S --noconfirm --needed unzip
pikaur -S --noconfirm --needed whois
pikaur -S --noconfirm --needed xautolock
pikaur -S --noconfirm --needed xclip
pikaur -S --noconfirm --needed inotify-tools
pikaur -S --noconfirm --needed iptables
pikaur -S --noconfirm --needed ebtables
pikaur -S --noconfirm --needed bridge-utils
pikaur -S --noconfirm --needed dnsmasq

echo "Installing text editors"
pikaur -S --noconfirm --needed geany
pikaur -S --noconfirm --needed neovim

echo "Installing WM"
pikaur -S --noconfirm --needed i3-gaps
pikaur -S --noconfirm --needed i3blocks
pikaur -S --noconfirm --needed i3lock

echo "Installing common software"
pikaur -S --noconfirm --needed alacritty
pikaur -S --noconfirm --needed android-tools
pikaur -S --noconfirm --needed android-udev-git
pikaur -S --noconfirm --needed dmenu
pikaur -S --noconfirm --needed clipmenu
pikaur -S --noconfirm --needed clipnotify
pikaur -S --noconfirm --needed dnsutils
pikaur -S --noconfirm --needed dunst
pikaur -S --noconfirm --needed gparted
pikaur -S --noconfirm --needed gpicview
pikaur -S --noconfirm --needed gtk-engine-murrine
pikaur -S --noconfirm --needed htop
pikaur -S --noconfirm --needed inkscape
pikaur -S --noconfirm --needed keepassxc
pikaur -S --noconfirm --needed lxappearance
pikaur -S --noconfirm --needed maim
pikaur -S --noconfirm --needed mupdf
pikaur -S --noconfirm --needed nitrogen
pikaur -S --noconfirm --needed pcmanfm
pikaur -S --noconfirm --needed picom
pikaur -S --noconfirm --needed redshift
pikaur -S --noconfirm --needed remmina
pikaur -S --noconfirm --needed screenfetch
pikaur -S --noconfirm --needed simplescreenrecorder
pikaur -S --noconfirm --needed subdl
pikaur -S --noconfirm --needed transmission-gtk
pikaur -S --noconfirm --needed zim

echo "Installing video software"
pikaur -S --noconfirm --needed mpv

echo "Installing browsers"
pikaur -S --noconfirm --needed firefox
pikaur -S --noconfirm --needed lynx

echo "Install virtualization software"

pikaur -S --noconfirm --needed virt-manager
pikaur -S --noconfirm --needed virt-viewer
pikaur -S --noconfirm --needed qemu
pikaur -S --noconfirm --needed vde2
pikaur -S --noconfirm --needed libguestfs

echo "Microcode update"
pikaur -S --noconfirm --needed amd-ucode

exit 0
