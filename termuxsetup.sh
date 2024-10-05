#!/data/data/com.termux/files/usr/bin/bash

# Script Information
SCRIPT_NAME="Termux Setup"
SCRIPT_VERSION="1.0"
DEVELOPER="Ringga"
DEV_USERNAME="@ringgarevanka"

# Enable strict error handling: 'set -e' exits on errors, 'set -u' treats unset variables as errors
set -eu

# ANSI color codes for formatting
RESET="\033[0m"

# Green Text
echo_green() {
    local COLOR="\033[1;32m"
    echo -e "${COLOR}$1${RESET}"
}

# Function to display header with script information
display_header() {
    clear
    echo_green "$SCRIPT_NAME $SCRIPT_VERSION By: $DEVELOPER ($DEV_USERNAME)"
}

# Function to display a message in green color
display_message() {
    local message="$1"
    display_header
    echo_green "$message"
    echo_green ""
}

# Function to update and upgrade packages
update_and_upgrade() {
    display_message "Updating and Upgrading Packages..."
    pkg update -y && pkg upgrade -y
}

# Function to setup storage using 'termux-setup-storage'
setup_storage() {
    display_message "Set up Storage..."
    termux-setup-storage
}

# Function to install a list of essential packages
install_packages() {
    display_message "Installing termux repository, termux packages, and essential packages..."

    local termux_repo=(
        x11-repo root-repo science-repo game-repo tur-repo
    )

    local termux_packages=(
        termux-am termux-am-socket termux-api termux-api-static termux-apt-repo termux-auth termux-create-package termux-elf-cleaner termux-exec termux-gui-bash termux-gui-c termux-gui-package termux-gui-pm termux-keyring termux-licenses termux-services termux-tools
    )

    local packages=(
        git curl wget nodejs-lts python-pip python openssl libffi clang perl php sqlite zsh nano shfmt dnsutils htop jq grep ffmpeg openssh pulseaudio fakeroot bc tsu fastfetch android-tools zip unzip proot-distro
    )

    # Loop and install
    for package in "${termux_repo[@]}" "${termux_packages[@]}" "${packages[@]}"; do
        pkg install -y "$package"
    done
}

# Function to install PHP Composer with signature verification for security
setup_php_composer() {
    display_message "Setting up PHP Composer..."

    local EXPECTED_SIGNATURE
    EXPECTED_SIGNATURE=$(wget -q -O - https://composer.github.io/installer.sig)
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"

    local ACTUAL_SIGNATURE
    ACTUAL_SIGNATURE=$(php -r "echo hash_file('SHA384', 'composer-setup.php');")

    if [ "$EXPECTED_SIGNATURE" = "$ACTUAL_SIGNATURE" ]; then
        php composer-setup.php --install-dir=/data/data/com.termux/files/usr/bin --filename=composer
        rm composer-setup.php
    else
        echo "ERROR: Invalid installer signature"
        rm composer-setup.php
        exit 1
    fi
}

# Function to install additional Python packages
setup_python_packages() {
    display_message "Installing additional Python packages..."

    local packages=(
        requests setuptools httpie NumPy pandas Flask Django SQLAlchemy scikit-learn Jupyter matplotlib seaborn plotly beautifulsoup4 FastAPI selenium scrapy Pillow pygame docker fabric
    )

    for package in "${packages[@]}"; do
        pip install --quiet --upgrade "$package"
    done
}

# Function to customize the Termux interface
customize_interface() {
    display_message "Customizing Termux Interface..."

    # Custom .bashrc file
    cat <<EOF >"$HOME/.bashrc"
# Optimized Termux Setup
clear; termux-reload-settings; fastfetch -l none
EOF

    # Custom termux.properties for extra keys
    mkdir -p "$HOME/.termux"
    cat <<EOF >"$HOME/.termux/termux.properties"
# Optimized extra-keys layout
extra-keys = [[{key: 'ESC', popup: {macro: 'CTRL d', display: 'EXIT'}},{key: '/', popup: '&&'},{key: '-', popup: '|'},'HOME','UP','END','PGUP',{key: 'BKSP', popup: 'DEL'}],['TAB',{key: 'CTRL', popup: 'PASTE'},'ALT','LEFT','DOWN','RIGHT','PGDN',{key: 'KEYBOARD', popup: 'DRAWER'}]]
EOF
}

# Function to perform termux cleanup
clean_termux() {
    display_message "Cleaning Termux..."
    local DIR="/data/data/com.termux/"

    # Cleaning pkg and APT cache and removing unused packages
    echo_green "Cleaning PKG and APT cache, and removing unused packages..."
    # APT
    apt autoremove -y --purge
    apt autoclean
    apt clean
    # PKG
    pkg autoclean
    pkg clean
    echo_green "PKG and APT cleanup completed.\n"

    # Removing .bak and .tmp files
    echo_green "Removing .bak and .tmp files..."
    find "$DIR" -type f -name "*.bak" -o -name "*.tmp" -delete
    echo_green ".bak and .tmp files deleted.\n"

    # Cleaning cache and tmp directories
    echo_green "Cleaning cache and tmp directories..."
    find "$DIR" -type d -name ".cache" -o -name ".tmp" -exec rm -rf {} +
    echo_green "Cache and tmp directories cleaned.\n"

    # Cleaning Termux-specific temp directories
    echo_green "Cleaning Termux cache and tmp directories..."
    rm -rf "$HOME/.termux/tmp/*"
    echo_green "Termux cache and tmp directories cleaned.\n"

    # Clearing log files
    echo_green "Clearing log files..."
    find "$DIR" -type f -name "*.log" -delete
    echo_green "Log files deleted.\n"

    echo_green "Termux cleanup completed successfully."
}

# Main function to orchestrate the setup
main() {
    display_header

    update_and_upgrade
    setup_storage

    install_packages
    setup_php_composer
    setup_python_packages

    customize_interface
    clean_termux

    display_message "Reloading settings..."
    termux-reload-settings

    display_message "Setup completed!"
    rm "$0"
}

# Execute the main function
main
exit
