#!/bin/bash

# Check if the script is being run with sudo/root privileges
if [ "$EUID" -ne 0 ]; then
    echo "Please run the script with sudo or as root."
    exit 1
fi

# Install required dependencies
sudo apt-get install ninja-build gettext cmake unzip curl

# Create ~/code if it doesn't exist
code_directory="$HOME/code"
if [ ! -d "$code_directory" ]; then
    mkdir -p "$code_directory"
fi

# Change into ~/code and clone Neovim repository
cd "$code_directory" || exit
git clone https://github.com/neovim/neovim.git

# Change into neovim directory and build
cd neovim || exit
make CMAKE_BUILD_TYPE=RelWithDebInfo

# Ask the user if there are any errors before proceeding
read -rp "If you saw no errors type y (y/n): " user_input
if [ "$user_input" != "y" ]; then
    echo "Aborting the build process."
    exit 1
fi

echo "Changing into build directory, creating DEB package, and installing..."
cd build || exit
cpack -G DEB
sudo dpkg -i nvim-linux64.deb

echo "Neovim installed successfully"

echo "Preparing to install ripgrep (used by telescope btw)"

read -rp "Install ripgrep 14.1.0 (y) or do you want to check if there's a newer version at https://github.com/BurntSushi/ripgrep/releases/ (n)? (y/n): " user_input
if [ "$user_input" != "n" ]; then
    echo "Skipping installing ripgrep..."
    exit 1
fi

echo "Download and install ripgrep..."
cd "$code_directory" || exit
curl -LO https://github.com/BurntSushi/ripgrep/releases/download/14.1.0/ripgrep_14.1.0-1_amd64.deb
sudo dpkg -i ripgrep_14.1.0-1_amd64.deb

echo "ripgrep installed successfully"
