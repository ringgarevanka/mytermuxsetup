#!/bin/bash
#!/system/bin/sh
# Termux Setup By: rvnull00 (ringgarevanka)
echo "Termux Setup By: rvnull00"

# update
echo "Updating and Upgrade Packages"
pkg update -y && apt update -y
pkg upgrade -y && apt upgrade -y

# clean
echo "Cleaning Packages"
pkg autoclean && pkg clean

# install repo
echo "Installing repo"
pkg install x11-repo
pkg install root-repo

# Termux additional requirements
echo "Installing Termux additional requirements"
pkg install termux-exec
pkg install termux-api

# setup storage
echo "Settingup storage"
termux-setup-storage

# upgrade repo
echo "Upgrading repo"
termux-upgrade-repo

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

# Utilities and productivity tools
pkg install nano -y
pkg install zsh -y
pkg install sqlite -y
pkg install sshpass -y
pkg install proot -y
pkg install android-tools -y

# Additional and entertainment tools
pkg install figlet -y
pkg install cowsay -y
pkg install w3m -y
pkg install ffmpeg -y

# php composer
echo "Installing and Setup PHP Composer for PHP"
curl -sS https://getcomposer.org/installer | php -- --install-dir=/data/data/com.termux/files/usr/bin --filename=composer

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

# Go home
cd $HOME

# setup fastfetch
echo "Installing And Settingup Fastfetch"
pkg install fastfetch -y
echo "#!/system/bin/sh
clear
printf \"Reloading...\"
termux-reload-settings
clear
fastfetch -l none
echo \"\"
"> .bashrc

# reload settings
echo "Reloading..."
termux-reload-settings

# fix
echo "Fixing"
termux-chroot
ls /usr

# EXIT
exit
exit
