#!/data/data/com.termux/files/usr/bin/bash

# Termux Setup By: rvnull00 (ringgarevanka), optimized version

set -e # Exit immediately if a command exits with a non-zero status

echo "Termux Setup By: rvnull00 (ringgarevanka) - V1"

update_and_upgrade() {
    echo "Updating and Upgrading Packages"
    pkg update -y && pkg upgrade -y
    apt update -y && apt upgrade -y
}

install_packages() {
    local packages=(
        x11-repo root-repo tur-repo termux-exec termux-api termux-x11-nightly
        curl wget git zip unzip openssh python python2 nodejs-lts perl php ruby golang rust
        shfmt clang libffi openssl fakeroot htop httping dnsutils jq libxml2-utils grep bc tsu
        nano zsh sqlite sshpass proot proot-distro android-tools figlet cowsay w3m ffmpeg pulseaudio fastfetch
    )
    
    echo "Installing packages"
    pkg install -y "${packages[@]}"
}

setup_php_composer() {
    echo "Installing and Setting up PHP Composer"
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/data/data/com.termux/files/usr/bin --filename=composer
}

setup_python_packages() {
    echo "Installing Python additional packages"
    pip install --upgrade pip setuptools requests requests[socks] httpie ddgr
}

setup_interface() {
    echo "Setting up Termux Interface"
    echo '# Termux Setup By: rvnull00 (ringgarevanka)
clear
termux-reload-settings
fastfetch -l none' > "$HOME/.bashrc"

    mkdir -p "$HOME/.termux"
    echo '# Termux Setup By: rvnull00 (ringgarevanka)
extra-keys = [
    [{key: "F1", popup: "F7"},{key: "F2", popup: "F8"},{key: "F3", popup: "F9"},{key: "F4", popup: "F10"},{key: "F5", popup: "F11"},{key: "F6", popup: "F12"},"FN","SHIFT"],
    [{key: ESC, popup: {macro: "CTRL d", display: "EXIT"}},{key: "/", popup: "&&"},{key: "|", popup: "-"},"HOME","UP","END","PGUP",{key: "BKSP", popup: "DEL"}],
    ["TAB",{key: "CTRL", popup: "PASTE"},"ALT","LEFT","DOWN","RIGHT","PGDN",{key: "KEYBOARD", popup: "DRAWER"}]
]' > "$HOME/.termux/termux.properties"
}

main() {
    clear
    update_and_upgrade
    clear
    
    echo "Setting up storage"
    termux-setup-storage
    clear
    
    echo "Cleaning Packages"
    pkg autoclean && pkg clean
    clear
    
    install_packages
    clear
    
    echo "Upgrading repo"
    termux-upgrade-repo
    clear
    
    setup_php_composer
    clear
    
    setup_python_packages
    clear
    
    cd "$HOME"
    
    setup_interface
    clear
    
    update_and_upgrade
    clear
    
    echo "Cleaning Packages"
    pkg autoclean && pkg clean
    clear
    
    echo "Upgrading repo"
    termux-upgrade-repo
    clear
    
    rm -rf mytermuxsetup
    
    echo "Reloading..."
    termux-reload-settings
    clear
    
    echo "Setup completed successfully!"
}

main
