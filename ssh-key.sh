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
echo "Creating key"
ssh-keygen -t rsa -b 4096 -C "icrunchbanger@gmail.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
xsel < ~/.ssh/id_rsa.pub
read -p "Input key to Github and press any key to continue... " -s
ssh -T git@github.com
git config --global user.name "icrunchbanger"
git config --global user.email "icrunchbanger@gmail.com"
echo "Done"
exit 0
