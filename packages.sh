#!/bin/bash
# Copyright (C) 2018 'icrunchbanger' icrunchbanger@gmail.com

# This software is licensed under the terms of the GNU General Public
# License version 2, as published by the Free Software Foundation, and
# may be copied, distributed, and modified under those terms.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

clear
echo "Updating repos"
sudo pacman  -Syu --noconfirm

if [[ ! $(command -v pikaur) ]]
then
    echo "Installing Pikaur"
    cd /tmp
    wget https://aur.archlinux.org/cgit/aur.git/snapshot/pikaur.tar.gz
    tar zxvf pikaur.tar.gz
    cd pikaur
    makepkg -si --noconfirm
fi

sudo pikaur 	  -Syu

echo "Installing basic packages"
sudo pacman -S --noconfirm --needed xorg-server
sudo pacman -S --noconfirm --needed xorg-xinit xorg-xrdb xorg-xmodmap xf86-input-libinput
sudo pacman -S --noconfirm --needed openssh

echo "Installing sound packages"
sudo pacman -S --noconfirm --needed pulseaudio-alsa

echo "Installing fonts"
sudo pacman -S --noconfirm --needed ttf-dejavu       
sudo pacman -S --noconfirm --needed ttf-bitstream-vera 
sudo pacman -S --noconfirm --needed adobe-source-code-pro-fonts
sudo pikaur    -S --noconfirm --needed otf-font-awesome-4
sudo pikaur    -S --noconfirm --needed otf-san-francisco

echo "Installing basic tools"
sudo pacman -S --noconfirm --needed rsync
sudo pacman -S --noconfirm --needed ntp
sudo pacman -S --noconfirm --needed xsel
sudo pacman -S --noconfirm --needed unzip
sudo pacman -S --noconfirm --needed unrar
sudo pacman -S --noconfirm --needed cpio
sudo pacman -S --noconfirm --needed lzop
sudo pacman -S --noconfirm --needed imagemagick
sudo pacman -S --noconfirm --needed alsa-utils
sudo pacman -S --noconfirm --needed file-roller
sudo pacman -S --noconfirm --needed redshift
sudo pacman -S --noconfirm --needed numlockx
sudo pacman -S --noconfirm --needed htop
sudo pacman -S --noconfirm --needed xautolock
sudo pacman -S --noconfirm --needed compton
sudo pacman -S --noconfirm --needed dunst
sudo pacman -S --noconfirm --needed gtk-engine-murrine
sudo pacman -S --noconfirm --needed mtpfs
sudo pacman -S --noconfirm --needed fuse
sudo pacman -S --noconfirm --needed libmtp
sudo pacman -S --noconfirm --needed time
sudo pacman -S --noconfirm --needed dkms
sudo pacman -S --noconfirm --needed colordiff 
sudo pacman -S --noconfirm --needed screen
sudo pacman -S --noconfirm --needed gvfs gvfs-mtp
sudo pacman -S --noconfirm --needed bc
sudo pikaur    -S --noconfirm --needed neofetch
sudo pikaur    -S --noconfirm --needed ncftp


echo "Installing development tools"
sudo pacman -S --noconfirm --needed base-devel
sudo pacman -S --noconfirm --needed git
sudo pacman -S --noconfirm --needed python2-virtualenv
sudo pacman -S --noconfirm --needed jdk8-openjdk
sudo pacman -S --noconfirm --needed jre8-openjdk 
sudo pacman -S --noconfirm --needed squashfs-tools
sudo pacman -S --noconfirm --needed perl-switch
sudo pacman -S --noconfirm --needed maven
sudo pacman -S --noconfirm --needed pkg-config 
sudo pacman -S --noconfirm --needed python-pip
sudo pacman -S --noconfirm --needed subdl
sudo pacman -S --noconfirm --needed android-udev-git 

echo "Installing languages"
sudo pacman -S --noconfirm --needed python3

echo "Installing editors"
sudo pacman -S --noconfirm --needed geany
sudo pacman -S --noconfirm --needed vim

echo "Installing WM /i3/"
sudo pacman -S --noconfirm --needed i3blocks
sudo pacman -S --noconfirm --needed rxvt-unicode
sudo pikaur    -S --noconfirm --needed i3-gaps i3lock-blur
sudo pikaur    -S --noconfirm --needed paper-icon-theme-git

echo "Installing common software"
sudo pacman -S --noconfirm --needed gimp
sudo pacman -S --noconfirm --needed inkscape
sudo pacman -S --noconfirm --needed transmission-gtk
sudo pacman -S --noconfirm --needed scrot
sudo pacman -S --noconfirm --needed lxappearance
sudo pacman -S --noconfirm --needed mpv
sudo pacman -S --noconfirm --needed pcmanfm
sudo pacman -S --noconfirm --needed rofi
sudo pacman -S --noconfirm --needed nitrogen
sudo pacman -S --noconfirm --needed feh
sudo pacman -S --noconfirm --needed simple-scan
sudo pacman -S --noconfirm --needed simplescreenrecorder
sudo pacman -S --noconfirm --needed gparted
sudo pacman -S --noconfirm --needed zathura zathura-pdf-poppler 
sudo pacman -S --noconfirm --needed xfburn

echo "Installing video software"
sudo pacman -S --noconfirm --needed mpv

echo "Installing browsers"
sudo pacman -S --noconfirm --needed chromium
sudo pacman -S --noconfirm --needed elinks

echo "Install virtualization software"
sudo pacman -S --noconfirm --needed virtualbox
sudo pacman -S --noconfirm --needed linux-headers

echo "Install shell"
sudo pikaur    -S --noconfirm --needed oh-my-zsh-git

echo "Microcode update"
sudo pacman -S --noconfirm --needed intel-ucode 

echo "exec i3"  > ~/.xinitrc
sudo udevadm control --reload-rules
exit 0

