#!/data/data/com.termux/files/usr/bin/bash

# Termux Setup By: rvnull00 (ringgarevanka) - V1.2f

set -euo pipefail # Additional options for strict error handling

echo "Termux Setup By: rvnull00 (ringgarevanka) - V1.2f"

update_and_upgrade() {
    echo "Updating and Upgrading Packages"
    pkg update -y && pkg upgrade -y
}

install_packages() {
    local packages=(
        x11-repo root-repo tur-repo termux-exec termux-api
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
    pip install --upgrade pip setuptools requests 'requests[socks]' httpie ddgr
}

setup_interface() {
    echo "Setting up Termux Interface"
    cat << EOF > $HOME/.bashrc
# Termux Setup By: rvnull00 (ringgarevanka)
rm -rf .bash_history; clear; termux-reload-settings; fastfetch -l none
EOF

    mkdir -p $HOME/.termux
    cat << EOF > $HOME/.termux/termux.properties
# Termux Setup By: rvnull00 (ringgarevanka)
extra-keys = [[{key: 'F1', popup: 'F7'},{key: 'F2', popup: 'F8'},{key: 'F3', popup: 'F9'},{key: 'F4', popup: 'F10'},{key: 'F5', popup: 'F11'},{key: 'F6', popup: 'F12'},'FN','SHIFT'],[{key: ESC, popup: {macro: 'CTRL d', display: 'EXIT'}},{key: '/', popup: '&&'},{key: '-', popup: '|'},'HOME','UP','END','PGUP',{key: 'BKSP', popup: 'DEL'}],['TAB',{key: 'CTRL', popup: 'PASTE'},'ALT','LEFT','DOWN','RIGHT','PGDN',{key: 'KEYBOARD', popup: 'DRAWER'}]]
EOF
}

main() {
    clear
    update_and_upgrade
    
    echo "Setting up storage"
    termux-setup-storage
    
    echo "Cleaning Packages"
    pkg autoclean && pkg clean
    
    install_packages
    setup_php_composer
    setup_python_packages
    
    cd "$HOME"
    setup_interface
    
    update_and_upgrade
    
    echo "Cleaning Packages"
    pkg autoclean && pkg clean
    
    rm -rf mytermuxsetup
    
    echo "Reloading..."
    termux-reload-settings
    
    echo "Setup completed successfully!"
}

main
