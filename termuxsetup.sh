#!/bin/bash
#!/system/bin/sh

# Termux Setup By: rvnull00 (ringgarevanka)
echo "Termux Setup By: rvnull00 (ringgarevanka)"
clear

# update
echo "Updating and Upgrade Packages"
pkg update -y && apt update -y
pkg upgrade -y && apt upgrade -y
clear

# setup storage
echo "Settingup storage"
termux-setup-storage
clear

# clean
echo "Cleaning Packages"
pkg autoclean && pkg clean
clear

# install repo
echo "Installing repo"
pkg install x11-repo -y
pkg install root-repo -y
clear

# Termux additional requirements
echo "Installing Termux additional requirements"
pkg install termux-exec -y
pkg install termux-api -y
pkg install termux-x11-nightly -y
clear

# upgrade repo
echo "Upgrading repo"
termux-upgrade-repo
clear

# install
echo "Installing or Updating additional packages"
# File management and networking packages
pkg install curl -y
pkg install wget -y
pkg install git -y
pkg install zip -y
pkg install unzip -y
pkg install openssh -y
# Programming languages and runtimes
pkg install python -y
pkg install python2 -y
pkg install nodejs-lts -y
pkg install perl -y
pkg install php -y
pkg install ruby -y
pkg install golang -y
pkg install rust -y
# Development and build tools
pkg install shfmt -y
pkg install clang -y
pkg install libffi -y
pkg install openssl -y
pkg install fakeroot -y
# System monitoring and management tools
pkg install htop -y
pkg install httping -y
pkg install dnsutils -y
pkg install jq -y
pkg install libxml2-utils -y
pkg install grep -y
pkg install bc -y
pkg install tsu -y
# Utilities and productivity tools
pkg install nano -y
pkg install zsh -y
pkg install sqlite -y
pkg install sshpass -y
pkg install proot -y
pkg install proot-distro -y
pkg install android-tools -y
# Additional and entertainment tools
pkg install figlet -y
pkg install cowsay -y
pkg install w3m -y
pkg install ffmpeg -y
pkg install pulseaudio -y
# Interface
pkg install fastfetch -y
clear

# php composer
echo "Installing and Setup PHP Composer for PHP"
curl -sS https://getcomposer.org/installer | php -- --install-dir=/data/data/com.termux/files/usr/bin --filename=composer
clear

# pip install
echo "Installing Python additional packages"
# Upgrade pip and setuptools
pip install --upgrade pip setuptools
# Install requests
pip install requests
# Install requests with SOCKS support
pip install -U requests[socks]
# Install httpie
pip install --upgrade httpie
# Install ddgr
pip install ddgr
clear

# Go home
cd $HOME

# setup interface
echo "Settingup Termux Interface"
# fastfetch
echo "# Termux Setup By: rvnull00 (ringgarevanka)
clear
printf \"Loading...\"
termux-reload-settings
clear
fastfetch -l none
"> .bashrc
# extra keys
echo "# Termux Setup By: rvnull00 (ringgarevanka)
extra-keys = [[{key: 'F1', popup: 'F7'},{key: 'F2', popup: 'F8'},{key: 'F3', popup: 'F9'},{key: 'F4', popup: 'F10'},{key: 'F5', popup: 'F11'},{key: 'F6', popup: 'F12'},'FN','SHIFT'],[{key: ESC, popup: {macro: 'CTRL d', display: 'EXIT'}},{key: '/', popup: '&&'},{key: '|', popup: '-'},'HOME','UP','END','PGUP',{key: 'BKSP', popup: 'DEL'}],['TAB',{key: 'CTRL', popup: 'PASTE'},'ALT','LEFT','DOWN','RIGHT','PGDN',{key: 'KEYBOARD', popup: 'DRAWER'}]]
"> .termux/termux.properties
clear

# update (again)
echo "Updating and Upgrade Packages"
pkg update -y && apt update -y
pkg upgrade -y && apt upgrade -y
clear

# clean (again)
echo "Cleaning Packages"
pkg autoclean && pkg clean
clear

# upgrade repo (again)
echo "Upgrading repo"
termux-upgrade-repo
clear

# remove
rm -rf mytermuxsetup

# reload settings
echo "Reloading..."
termux-reload-settings
clear

# EXIT
exit