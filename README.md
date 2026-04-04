# NixOS Configuration

## 1. Directory Structure

This repository is structured to support multiple hosts with shared configuration:

- **`flake.nix`**: Entry point defining system configurations (`homepc` and `mylaptop`).
- **`nixos/`**: System-level configurations.
    - **`common.nix`**: Shared settings, packages, and users applicable to all hosts.
    - **`homepc/`**: Configuration specific to the desktop PC (Nvidia drivers, extra storage).
    - **`mylaptop/`**: Configuration specific to the laptop.
- **`users/vd/`**: User-specific configuration (Home Manager), including dotfiles (`config/`).

## 2. Fresh Installation Guide

After installing NixOS and rebooting into your new system, follow these steps to apply this configuration.

### Step 1: Get the Configuration

Install Git (if not already available) and clone this repository:

```bash
# Enter a temporary shell with git
nix-shell -p git

# Clone your repository (replace URL with your actual repo)
git clone https://github.com/lvdund/nixos-config /etc/nixos/nixos-config
cd /etc/nixos/nixos-config 
```

### Step 2: Hardware Configuration

**Crucial:** You must generate the hardware configuration specific to your machine to ensure bootloaders and filesystems are correct.

**For Laptop:**
```bash
nixos-generate-config --show-hardware-config > nixos/mylaptop/hardware-configuration.nix
```

**For Home PC:**
```bash
nixos-generate-config --show-hardware-config > nixos/homepc/hardware-configuration.nix
```

### Step 3: Apply Configuration

Apply the flake configuration for your specific host:

**For Laptop:**
```bash
sudo nixos-rebuild switch --flake .#mylaptop
```

**For Home PC:**
```bash
sudo nixos-rebuild switch --flake .#homepc
```

**Update:**
```bash
nix flake update
```

## 3. Git Configuration

Set up your global git identity:

```bash
git config --global user.email "lvdund@gmail.com"
git config --global user.name "lvdund"
```

## 3. Lang Setup

- Install essential Go tools and utilities:

```bash
go install golang.org/x/tools/gopls@latest
go install github.com/go-delve/delve/cmd/dlv@latest
go install mvdan.cc/gofumpt@latest
go install mvdan.cc/sh/v3/cmd/shfmt@latest
go install golang.org/x/tools/cmd/goimports@latest
go install github.com/fatih/gomodifytags@latest
go install github.com/jesseduffield/lazygit@latest
go install github.com/jesseduffield/lazydocker@latest
go install github.com/josharian/impl@latest
```
- npm global installations:

```bash
mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'
npm install -g tree-sitter-cli

```
