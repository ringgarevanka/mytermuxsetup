#!/bin/bash
#!/system/bin/sh
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
pkg install curl -y
pkg install perl -y
pkg install git -y
pkg install wget -y
pkg install zip -y
pkg install unzip -y
pkg install python2 -y
pkg install python -y
pkg install nodejs-lts -y
pkg install jq -y
pkg install libxml2-utils -y
pkg install grep -y
pkg install bc -y
pkg install htop -y
pkg install figlet -y
pkg install httping -y
pkg install dnsutils -y
pkg install openssh -y
pkg install ffmpeg -y
pkg install php -y
pkg install nano -y
pkg install zsh -y
pkg install clang -y
pkg install libffi -y
pkg install openssl -y
pkg install w3m -y
pkg install cowsay -y
pkg install ruby -y
pkg install rust -y
pkg install sqlite -y
pkg install fakeroot -y
pkg install sshpass -y
pkg install golang -y
pkg install proot -y
# php composer
echo "Installing and Setup PHP Composer for PHP"
curl -sS https://getcomposer.org/installer | php -- --install-dir=/data/data/com.termux/files/usr/bin --filename=composer
# pip install
echo "Installing Python additional packages"
pip install --upgrade pip setuptools
pip install --upgrade httpie
pip install -U requests[socks]
pip install requests
pip install ddgr
# fix
echo "Fixing"
termux-chroot
ls /usr
# reload settings
echo "Reloading..."
termux-reload-settings
cd $HOME
# setup fastfetch
echo "Installing And Settingup FastFetch"
pkg install fastfetch -y
echo "#!/system/bin/sh
clear
printf \"Reloading...\"
termux-reload-settings
sleep 1
clear
fastfetch -l none
echo \"\"
"> .bashrc
# EXIT
logout && exit
