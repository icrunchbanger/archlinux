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
echo "Buckle up"
cd ~
sudo rm -rf /usr/lib/i3blocks
rm -rf ~/.config/i3 
mkdir -p .config/mpv/scripts .config/dunst Downloads Documents Music Pictures/Wallpapers Pictures/Screenshots bin github tdl tmp/postinstall opt
cd ~/tmp/postinstall
curl https://git.io/vpryf > ~/.config/mpv/mpv.conf
curl https://git.io/vpryU > ~/.config/mpv/scripts/subdl.lua
git clone https://github.com/icrunchbanger/android
git clone https://github.com/icrunchbanger/dotfiles
git clone https://github.com/BunsenLabs/bunsen-themes.git
wget https://git.io/vprDF https://git.io/vprDp
wget https://dl.google.com/android/repository/platform-tools-latest-linux.zip
sudo mv vprDF /usr/local/bin/sha256chk.sh
sudo mv vprDp /usr/local/bin/git-push.sh
unzip platform-tools-latest-linux.zip -d android
sudo mv android/platform-tools/{adb,fastboot,dmtracedump,e2fsdroid,etc1tool,hprof-conv,make_f2fs,mke2fs,mke2fs.conf,sload_f2fs,sqlite3} /usr/local/bin
sudo mv android/*.sh /usr/local/bin
cp -r dotfiles/i3 ~/.config
cp dotfiles/.Xdefaults ~
cp dotfiles/.zshrc ~
cp dotfiles/dunstrc ~/.config/dunst
sudo cp -r dotfiles/i3blocks /usr/lib
sudo cp -r dotfiles/i3exit /usr/local/bin
sudo cp -r dotfiles/blurlock /usr/local/bin
sudo cp -r bunsen-themes/themes/* /usr/share/themes
sudo chmod +x /usr/local/bin/*
rm -rf ~/tmp/postinstall
exit 0



