#!/data/data/com.termux/files/usr/bin/bash

# Script Information
SCRIPT_NAME="Termux Setup"
SCRIPT_VERSION="1.0"
SCRIPT_VERSION_BUILD="241071835"
DEVELOPER="Ringga"
DEV_USERNAME="@ringgarevanka"

# This script initializes a safe execution environment.
initialize_environment() {
    # Enable strict error handling:
    # 'set -e' will exit the script if any command fails
    # 'set -u' will treat unset variables as errors
    set -eu

    # Trap to disable the CTRL+Z key combination
    # trap '' SIGTSTP

    # Trap for errors, signals, and network issues:
    # The script will automatically delete itself if an error occurs or if it receives SIGINT, SIGTERM, or SIGHUP signals
    trap 'rm -rf "$0"; exit 1' ERR SIGINT SIGTERM SIGHUP SIGTSTP

    # Function to check network availability:
    # If the network is unavailable (cannot ping 8.8.8.8),
    # this script will delete itself and exit with status 1
    check_network() {
        if ! ping -c 1 8.8.8.8 &> /dev/null; then
            rm -rf "$0"
            exit 1
        fi
    }

    # Call the function to check network connectivity
    check_network
}

# ANSI color codes for formatting
RESET="\033[0m"

# Green Text
display_in_green() {
    local COLOR="\033[1;32m"
    echo -e "${COLOR}$1${RESET}"
}

# Function to display header with script information
show_header() {
    clear
    display_in_green "$SCRIPT_NAME $SCRIPT_VERSION ($SCRIPT_VERSION_BUILD) By: $DEVELOPER ($DEV_USERNAME)"
}

# Function to display a message in green color
show_message() {
    local message="$1"
    show_header
    display_in_green "$message"
    display_in_green ""
}

# Function to update and upgrade packages
perform_update_and_upgrade() {
    show_message "Updating and Upgrading Packages..."
    pkg update -y && pkg upgrade -y
}

# Function to set up storage using 'termux-setup-storage'
configure_storage() {
    show_message "Setting up Storage..."
    termux-setup-storage
}

# Function to install a list of essential packages
install_essential_packages() {
    local termux_repositories=(
        x11-repo root-repo science-repo game-repo tur-repo
    )

    local termux_packages=(
        termux-am termux-am-socket termux-api termux-api-static termux-apt-repo termux-auth termux-elf-cleaner termux-exec termux-keyring termux-licenses termux-services termux-tools
    )

    local additional_packages=(
        git curl wget nodejs-lts python-pip python python-tkinter python-numpy electrum opencv-python asciinema matplotlib python-cryptography openssl libffi libcrypt clang perl php sqlite zsh nano shfmt dnsutils htop jq grep ffmpeg openssh pulseaudio fakeroot bc tsu fastfetch android-tools zip unzip proot-distro
    )

    # Loop and install each package
    for package in "${termux_repositories[@]}"; do
        show_message "Adding Termux repository '$package'..."
        pkg install -y "$package"
        display_in_green "Successfully added $package"
        sleep 1
    done

    for package in "${termux_packages[@]}"; do
        show_message "Installing Termux package '$package'..."
        pkg install -y "$package"
        display_in_green "Successfully installed $package"
        sleep 1
    done

    for package in "${additional_packages[@]}"; do
        show_message "Installing additional package '$package'..."
        pkg install -y "$package"
        display_in_green "Successfully installed $package"
        sleep 1
    done
}

# Function to install PHP Composer with signature verification for security
setup_php_composer() {
    show_message "Setting up PHP Composer..."

    local EXPECTED_SIGNATURE
    EXPECTED_SIGNATURE=$(wget -q -O - https://composer.github.io/installer.sig)
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"

    local ACTUAL_SIGNATURE
    ACTUAL_SIGNATURE=$(php -r "echo hash_file('SHA384', 'composer-setup.php');")

    if [ "$EXPECTED_SIGNATURE" = "$ACTUAL_SIGNATURE" ]; then
        php composer-setup.php --install-dir=/data/data/com.termux/files/usr/bin --filename=composer
        rm composer-setup.php
        display_in_green "PHP Composer installed successfully."
    else
        echo "ERROR: Invalid installer signature"
        rm composer-setup.php
        exit 1
    fi
}

# Function to install additional Python packages
install_additional_python_packages() {
    local packages=(
        setuptools httpie beautifulsoup4 numpy electrum asciinema matplotlib
    )

    for package in "${packages[@]}"; do
        show_message "Installing additional Python package '$package'..."
        pip install --quiet --upgrade "$package"
        display_in_green "Successfully installed or updated $package"
        sleep 1
    done
}

# Function to customize the Termux interface
customize_termux_interface() {
    show_message "Customizing Termux Interface..."

    # Create a custom .bashrc file for user settings
    cat <<EOF >"$HOME/.bashrc"
# Optimized Termux Setup
clear
termux-reload-settings
fastfetch -l none
EOF

    # Create a custom termux.properties file for extra keys
    mkdir -p "$HOME/.termux"
    cat <<EOF >"$HOME/.termux/termux.properties"
# Optimized extra-keys layout
extra-keys = [[{key: 'ESC', popup: {macro: 'CTRL d', display: 'EXIT'}},{key: '/', popup: '&&'},{key: '-', popup: '|'},'HOME','UP','END','PGUP',{key: 'BKSP', popup: 'DEL'}],['TAB',{key: 'CTRL', popup: 'PASTE'},'ALT','LEFT','DOWN','RIGHT','PGDN',{key: 'KEYBOARD', popup: 'DRAWER'}]]
EOF
}

# Function to clean up the Termux environment
perform_termux_cleanup() {
    show_message "Cleaning Termux environment..."
    local DIR="/data/data/com.termux/"

    # Clean up package and APT cache, and remove unused packages
    display_in_green "Cleaning package and APT cache, and removing unused packages..."
    apt autoremove -y --purge
    apt autoclean
    apt clean
    pkg autoclean
    pkg clean
    display_in_green "Package and APT cleanup completed.\n"

    # Remove .bak and .tmp files
    display_in_green "Removing .bak and .tmp files..."
    find "$DIR" -type f -name "*.bak" -o -name "*.tmp" -delete
    display_in_green ".bak and .tmp files deleted.\n"

    # Clean cache and temporary directories
    display_in_green "Cleaning cache and temporary directories..."
    find "$DIR" -type d -name ".cache" -o -name ".tmp" -exec rm -rf {} +
    display_in_green "Cache and temporary directories cleaned.\n"

    # Clean Termux-specific temporary directories
    display_in_green "Cleaning Termux cache and temporary directories..."
    rm -rf "$HOME/.termux/tmp/*"
    display_in_green "Termux cache and temporary directories cleaned.\n"

    # Clear log files
    display_in_green "Clearing log files..."
    find "$DIR" -type f -name "*.log" -delete
    display_in_green "Log files deleted.\n"

    display_in_green "Termux cleanup completed successfully."
}

# Function to clear traps and exit safely
exit_cleanly() {
    # Remove trap to ENABLE CTRL+Z
    trap - SIGTSTP

    # Remove traps for errors, signals, and network problems
    trap - ERR SIGINT SIGTERM SIGHUP

    # Remove this script
    rm -rf "$0"

    # Exit the script
    exit 0
}

# Main function to orchestrate the setup
main() {
    show_header

    perform_update_and_upgrade
    configure_storage

    install_essential_packages
    setup_php_composer
    install_additional_python_packages

    customize_termux_interface
    perform_termux_cleanup

    show_message "Reloading settings..."
    termux-reload-settings

    show_message "Setup completed!"
}

# Execute the main function
initialize_environment
main
exit_cleanly