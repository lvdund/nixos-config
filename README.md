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
git clone https://github.com/lvdund/nixos-config ~/nixos-config
cd ~/nixos-config
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

## 3. Git Configuration

Set up your global git identity:

```bash
git config --global user.email "lvdund@gmail.com"
git config --global user.name "lvdund"
```

## 3. Go Tools Setup

Install essential Go tools and utilities:

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

## 4. NixOS Maintenance

### Initial Setup (Laptop)

When setting up the laptop for the first time:

1.  Generate the hardware configuration:
    ```bash
    nixos-generate-config --show-hardware-config > nixos/mylaptop/hardware-configuration.nix
    ```
2.  Apply the configuration:
    ```bash
    sudo nixos-rebuild switch --flake .#mylaptop
    ```

### Build and Apply Changes

**For Home PC:**
```bash
sudo nixos-rebuild switch --flake .#homepc
```

**For Laptop:**
```bash
sudo nixos-rebuild switch --flake .#mylaptop
```

To build and test without modifying the bootloader (good for temporary checks):

```bash
sudo nixos-rebuild test --flake .#homepc
# or
sudo nixos-rebuild test --flake .#mylaptop
```

### Updates

Update flake inputs (packages) to their latest versions:

```bash
nix flake update
```

### Cleanup and Garbage Collection

Clean up old generations, cache, and unused packages to free up space:

```bash
# Delete old generations (older than 7 days)
sudo nix-collect-garbage --delete-older-than 7d

# Optimize the store (deduplicate identical files)
nix-store --optimize

# Full cleanup (remove everything not currently in use - Use with caution)
nix-collect-garbage -d
```

### Troubleshooting

If you encounter lock file errors or need to regenerate it:

```bash
# Update specific input or regenerate lock
nix flake lock --update-input nixpkgs
```

If a build fails and you need to see why:

```bash
# Build with stack trace
nixos-rebuild build --flake .#homepc --show-trace
```
