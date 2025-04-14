#!/bin/bash

echo "===== Neovim Setup Helper ====="
echo "Installing missing dependencies and configuring your Neovim setup..."

# Install fd (for Telescope)
if ! command -v fd &> /dev/null; then
    echo "Installing fd for Telescope..."
    brew install fd
fi

# Install wget (for Mason)
if ! command -v wget &> /dev/null; then
    echo "Installing wget for Mason..."
    brew install wget
fi

# Install neovim npm package
echo "Installing neovim npm package..."
npm install -g neovim

# Install Python neovim module
echo "Installing Python neovim module..."
pip3 install pynvim

# Install Ruby neovim support
echo "Installing Ruby neovim support..."
gem install neovim

# Install luarocks
if ! command -v luarocks &> /dev/null; then
    echo "Installing luarocks..."
    brew install luarocks
fi

cp ./.wezterm.lua ~/

echo "Installation complete!"
echo "To finish setup, you'll need to run these commands inside Neovim:"
echo ":TSInstall regex jsonc"
echo ""
echo "Remember to restart Neovim after running these commands."
