#!/usr/bin/env bash

set -e

echo "================================================"
echo "Nix Home Manager Setup for Arch Linux"
echo "User: vd | i3 Window Manager Configuration"
echo "================================================"
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if running on Arch Linux
if ! command -v pacman &> /dev/null; then
    echo -e "${RED}Error: This script is designed for Arch Linux${NC}"
    exit 1
fi

echo -e "${BLUE}Step 1: Installing Nix Package Manager${NC}"
if ! command -v nix &> /dev/null; then
    echo "Installing Nix..."
    sh <(curl -L https://nixos.org/nix/install) --daemon
    
    # Source nix
    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    fi
else
    echo "Nix is already installed"
fi

echo ""
echo -e "${BLUE}Step 2: Enabling Experimental Features (flakes)${NC}"
mkdir -p ~/.config/nix
cat > ~/.config/nix/nix.conf << EOF
experimental-features = nix-command flakes
EOF
echo "Experimental features enabled"

echo ""
echo -e "${BLUE}Step 3: Installing System Dependencies${NC}"
read -p "Install system packages (xorg, i3, docker, pipewire)? [y/N] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    sudo pacman -S --needed \
        xorg-server xorg-xinit \
        i3-wm lightdm lightdm-gtk-greeter \
        docker docker-compose \
        pipewire pipewire-pulse pipewire-alsa \
        networkmanager
    
    echo "Enabling services..."
    sudo systemctl enable --now docker
    sudo systemctl enable --now NetworkManager
    sudo usermod -aG docker $USER
    
    echo -e "${GREEN}System packages installed${NC}"
fi

echo ""
echo -e "${BLUE}Step 4: Setting up Home Manager${NC}"

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd "$SCRIPT_DIR"

echo "Building Home Manager configuration..."
nix run home-manager/release-25.11 -- switch --flake .#vd

echo ""
echo -e "${GREEN}Installation Complete!${NC}"
echo ""
echo "Next steps:"
echo "1. Log out and log back in (or reboot) to apply all changes"
echo "2. Set Fish as your default shell:"
echo "   echo \$(which fish) | sudo tee -a /etc/shells"
echo "   chsh -s \$(which fish)"
echo "3. Create ~/.xinitrc with: exec i3"
echo "4. Start i3 with: startx (or select i3 in LightDM)"
echo ""
echo "To update your configuration:"
echo "   home-manager switch --flake ~/.config/nixos-config/nix#vd"
echo ""
echo "Or use the alias after logging in with Fish shell:"
echo "   hmswitch"
echo ""
echo "Enjoy your Nix + i3 setup on Arch Linux!"
