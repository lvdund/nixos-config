# Nix Package Manager Setup for Arch Linux

This configuration provides a Nix Home Manager setup for Arch Linux with i3 window manager. It's based on the homepc configuration but streamlined for Arch Linux without NVIDIA, VirtualBox, Vagrant, and other NixOS-specific components.

## Features

- **i3 Window Manager**: Full i3wm configuration with keybindings, status bar, and utilities
- **Docker Support**: Docker and docker-compose with useful aliases
- **Fish Shell**: Configured with vi bindings and productivity aliases
- **Fonts**: Nerd Fonts and essential typography packages
- **Development Tools**: Git, Neovim, tmux, fzf, and more
- **User**: Configured for user `vd`

## Prerequisites

### 1. Install Nix Package Manager on Arch Linux

```bash
# Install Nix using the official installer
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon

# After installation, restart your shell or source the profile
source /etc/profile.d/nix.sh
```

### 2. Enable Flakes

Add the following to `~/.config/nix/nix.conf` (create if it doesn't exist):

```
experimental-features = nix-command flakes
```

Or create it with this command:

```bash
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf
```

### 3. Install Required System Packages (on Arch)

Some components need to be installed via pacman as they interact with the system level:

```bash
# X11 and i3 essentials (if not already installed)
sudo pacman -S xorg-server xorg-xinit i3-wm lightdm lightdm-gtk-greeter

# Docker (if using Docker)
sudo pacman -S docker docker-compose
sudo systemctl enable --now docker
sudo usermod -aG docker vd

# Audio (PipeWire or PulseAudio)
sudo pacman -S pipewire pipewire-pulse pipewire-alsa

# Network management
sudo pacman -S networkmanager
sudo systemctl enable --now NetworkManager
```

## Installation

### 1. Clone or Link This Configuration

If you already have the nixos-config repo:

```bash
# Create a symlink to easily access this configuration
ln -sf ~/nixos-config/nix ~/.config/nixos-config/nix
```

Or navigate to the nix directory:

```bash
cd ~/nixos-config/nix
```

### 2. Install Home Manager

```bash
# Build and activate the Home Manager configuration
nix run home-manager/release-25.11 -- switch --flake .#vd
```

### 3. Apply Configuration

After the initial setup, you can update your configuration with:

```bash
# From the nix directory
home-manager switch --flake .#vd

# Or use the alias defined in fish shell (after reloading shell)
hmswitch
```

## Post-Installation

### 1. Set Fish as Default Shell

```bash
# Add fish to valid shells
echo $(which fish) | sudo tee -a /etc/shells

# Change default shell
chsh -s $(which fish)
```

### 2. Configure X11 to Start i3

Create or edit `~/.xinitrc`:

```bash
#!/bin/sh
exec i3
```

Make it executable:

```bash
chmod +x ~/.xinitrc
```

### 3. Start i3

If using LightDM, select i3 from the session menu at login.

Or start manually:

```bash
startx
```

## Customization

### Editing Configuration

```bash
# Edit main configuration
nvim ~/.config/nixos-config/nix/configuration.nix

# Edit i3 configuration
nvim ~/.config/nixos-config/nix/modules/i3-arch.nix

# Edit Fish configuration
nvim ~/.config/nixos-config/nix/modules/fish.nix
```

After editing, apply changes:

```bash
home-manager switch --flake ~/.config/nixos-config/nix#vd
```

### Adding More Packages

Edit `configuration.nix` and add packages to `home.packages`:

```nix
home.packages = with pkgs; [
  # ... existing packages ...
  your-new-package
];
```

## Useful Aliases (Fish Shell)

After installing, these aliases will be available:

- `hm` - home-manager
- `hmswitch` - Apply Home Manager configuration
- `hmedit` - Edit main configuration file
- `d`, `dc`, `dps` - Docker shortcuts
- `ls`, `ll`, `lt` - Enhanced ls with lsd
- `cat` - Enhanced cat with bat
- `gs`, `ga`, `gc`, `gp` - Git shortcuts

## i3 Keybindings

- `Super + Enter` - Open terminal (kitty)
- `Super + d` - Application launcher (rofi)
- `Super + Shift + q` - Kill focused window
- `Super + h/j/k/l` - Focus windows (vim-like)
- `Super + Shift + h/j/k/l` - Move windows
- `Super + 1-9` - Switch workspaces
- `Super + Shift + 1-9` - Move to workspace
- `Super + f` - Fullscreen
- `Super + Shift + r` - Restart i3
- `Super + Shift + e` - Exit i3

## Troubleshooting

### Nix command not found

```bash
source /etc/profile.d/nix.sh
```

### Permission denied for Docker

```bash
sudo usermod -aG docker $USER
# Log out and log back in
```

### i3 not starting

Check X11 logs:

```bash
cat ~/.local/share/xorg/Xorg.0.log
```

Ensure you have a proper `.xinitrc` file.

## Differences from NixOS homepc Configuration

This Arch Linux setup differs from the NixOS homepc configuration:

- **Removed**: NVIDIA drivers, VirtualBox, Vagrant, gtp5g kernel module
- **Removed**: Gaming packages (Steam, gamescope, gamemode)
- **Modified**: i3 module adapted for Home Manager instead of system-level configuration
- **Simplified**: Uses Home Manager standalone instead of NixOS modules
- **System-level**: Some services (Docker daemon, X11, display manager) must be installed via pacman

## Maintenance

### Update packages

```bash
# Update flake inputs
cd ~/nixos-config/nix
nix flake update

# Apply updates
home-manager switch --flake .#vd
```

### Garbage collection

```bash
# Remove old generations
nix-collect-garbage -d

# Optimize nix store
nix-store --optimize
```

## Support

This configuration is designed for a minimal, focused i3 setup on Arch Linux. For the full NixOS experience with all features, use the homepc configuration on a NixOS system.
