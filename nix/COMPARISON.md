# Configuration Comparison: NixOS homepc vs Arch Linux Nix

## Overview

This document shows the differences between the original NixOS homepc configuration and the new Arch Linux Nix configuration.

## Architecture Differences

### NixOS homepc
- **Type**: Full NixOS system configuration
- **User**: vd
- **Modules**: System-level NixOS modules
- **Package Management**: System-wide Nix packages
- **Services**: Managed by NixOS systemd configuration

### Arch Linux Nix
- **Type**: Home Manager standalone configuration
- **User**: vd
- **Modules**: Home Manager modules
- **Package Management**: User-level Nix packages via Home Manager
- **Services**: User services via Home Manager; system services via systemd

## Removed Components

### 1. NVIDIA Drivers
**File**: `nixos/modules/nvidia.nix`
- Proprietary NVIDIA drivers
- CUDA support
- OpenGL configuration for NVIDIA

**Reason**: Not needed for this Arch setup

### 2. VirtualBox
**File**: `nixos/modules/virtualbox.nix`
- VirtualBox kernel modules
- Extension pack
- User groups for VirtualBox

**Reason**: Excluded per requirements

### 3. Vagrant
- Not explicitly in modules, but part of system packages
- Virtual machine orchestration

**Reason**: Excluded per requirements

### 4. GTP5G Kernel Module
**File**: `nixos/modules/gtp5g.nix`
- Custom kernel module for 5G networking
- Specific to telecom/networking research

**Reason**: Not needed for basic i3 setup

### 5. Gaming Components
Removed from i3 module:
- Steam
- Gamescope
- Gamemode

**Reason**: Keeping minimal, focused setup

### 6. NixOS-Specific Services
System-level configurations that don't apply to Arch:
- Boot loader configuration
- Kernel package selection
- System-level user management
- Filesystem mounts (like /mnt/mydata)
- Network sysctl settings

## Modified Components

### i3 Configuration

**NixOS homepc** (`nixos/modules/i3.nix`):
- System-level X server configuration
- LightDM display manager
- System services (pipewire, gvfs, tumbler)
- Gaming programs (Steam, gamescope)

**Arch Linux** (`nix/modules/i3-arch.nix`):
- Home Manager i3 configuration
- XSession configuration
- User-level services (dunst, picom)
- No gaming packages

### Docker Configuration

**NixOS homepc** (`nixos/modules/docker.nix`):
- System-level Docker daemon
- Virtualisation configuration
- User groups managed by NixOS

**Arch Linux** (`nix/modules/docker-arch.nix`):
- Docker CLI tools only
- Assumes Docker daemon installed via pacman
- Aliases and shell integration

### Common Packages

**NixOS homepc** (`nixos/common.nix`):
- System packages installed globally
- Imports virtualbox module

**Arch Linux** (`nix/configuration.nix`):
- User packages via Home Manager
- No virtualbox import

## Kept Components

### ✓ i3 Window Manager
- Core i3 functionality
- i3status, i3lock
- Rofi, dmenu
- Custom keybindings

### ✓ Development Tools
- Git, GitHub CLI
- Neovim, tmux
- fzf, fd, bat, ripgrep
- GCC, make

### ✓ Fish Shell
- Vi keybindings
- Custom aliases
- Functions and completions

### ✓ Fonts
- Nerd Fonts (FiraCode, JetBrainsMono, Hack, Iosevka)
- Noto fonts
- Font Awesome, Material Icons

### ✓ Desktop Environment Tools
- Kitty terminal
- Dunst notifications
- Picom compositor
- Thunar file manager
- feh, maim

### ✓ Audio/Video
- PipeWire (system-level on Arch)
- PulseAudio compatibility
- Pavucontrol
- VLC

### ✓ User Configuration
- User: vd
- Groups: networkmanager, wheel, video, audio
- Same permission structure

## Installation Approach

### NixOS homepc
```bash
sudo nixos-rebuild switch --flake .#homepc
```

### Arch Linux Nix
```bash
# Install Nix first
sh <(curl -L https://nixos.org/nix/install) --daemon

# Then install Home Manager
home-manager switch --flake .#vd
```

## File Structure

### NixOS homepc
```
nixos/
├── common.nix
├── homepc/
│   ├── configuration.nix
│   └── hardware-configuration.nix
└── modules/
    ├── i3.nix
    ├── docker.nix
    ├── virtualbox.nix (REMOVED)
    ├── nvidia.nix (REMOVED)
    ├── gtp5g.nix (REMOVED)
    ├── fish.nix
    ├── fonts.nix
    └── input.nix
```

### Arch Linux Nix
```
nix/
├── configuration.nix
├── flake.nix
├── README.md
├── install-arch.sh
├── COMPARISON.md
└── modules/
    ├── i3-arch.nix
    ├── docker-arch.nix
    ├── fish.nix
    └── fonts.nix
```

## Summary

The Arch Linux configuration maintains the core i3 + development setup while removing:
- Hardware-specific drivers (NVIDIA)
- Virtualization (VirtualBox, Vagrant)
- Specialized kernel modules (gtp5g)
- Gaming suite (Steam, etc.)
- NixOS system-level configurations

This results in a clean, minimal i3 environment managed through Home Manager on Arch Linux, perfect for development and daily use without the overhead of full NixOS or unnecessary components.
