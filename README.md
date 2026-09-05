# NixOS & nix-darwin Configuration

Multi-host flake managing four machines with shared user configuration:

| Host | Platform | Flake output | Rebuild command |
| --- | --- | --- | --- |
| `homepc` | NixOS (x86_64-linux) | `nixosConfigurations.homepc` | `sudo nixos-rebuild switch --flake .#homepc` |
| `mylaptop` | NixOS (x86_64-linux) | `nixosConfigurations.mylaptop` | `sudo nixos-rebuild switch --flake .#mylaptop` |
| `myserver` | NixOS (x86_64-linux, headless) | `nixosConfigurations.myserver` | `sudo nixos-rebuild switch --flake .#myserver` |
| `macvd` | macOS (aarch64-darwin) | `darwinConfigurations.macvd` | `sudo darwin-rebuild switch --flake .#macvd` |

## 1. Directory Structure

- **`flake.nix`**: Entry point — system configurations for all hosts
    (`nixosConfigurations` for Linux, `darwinConfigurations` for macOS) and the
    `repoRoot` path passed to user modules for dotfile symlinks
    (`/etc/nixos/nixos-config` on Linux, `/Users/lvdund/nixos-config` on macOS).
- **`nixos/`**: Linux system-level configuration.
    - **`common.nix`**: Shared settings, packages, and users for all Linux hosts
        (desktop-oriented — `myserver` skips it and imports only the headless
        modules: docker, code, fish, sysctl, tmpdir).
    - **`modules/`**: Shared Linux modules (code, docker, fonts, network, niri, nvidia…).
    - **`homepc/`**, **`mylaptop/`**, **`myserver/`**: Per-host configurations (hardware, drivers, storage).
- **`darwin/macvd/`**: macOS system-level configuration (nix-darwin).
- **`users/vd/`**: Per-host Home Manager users (`homepc.nix`, `mylaptop.nix`,
    `myserver.nix`, `macvd.nix`).
- **`users/modules/`**: Shared cross-platform Home Manager modules
    (browser, direnv, fish, game, git, niri, nvim, office).
- **`config/`**: Actual dotfiles (nvim, fish, kitty, niri, waybar, mako…),
    symlinked into place by Home Manager via `repoRoot`.
- **`notes/`**: Setup notes and plans (e.g. `nix-darwin-setup-plan.md`).

## 2. Linux (NixOS) — Fresh Installation

After installing NixOS and rebooting into your new system:

### Step 1: Get the Configuration

```bash
# Enter a temporary shell with git
nix-shell -p git

# Clone your repository
git clone git@github.com:lvdund/nixos-config.git /etc/nixos/nixos-config
cd /etc/nixos/nixos-config
```

### Step 2: Hardware Configuration

**Crucial:** Generate the hardware configuration specific to your machine so
bootloaders and filesystems are correct:

```bash
# For Laptop:
nixos-generate-config --show-hardware-config > nixos/mylaptop/hardware-configuration.nix

# For Home PC:
nixos-generate-config --show-hardware-config > nixos/homepc/hardware-configuration.nix

# For Server (replaces the checked-in placeholder):
nixos-generate-config --show-hardware-config > nixos/myserver/hardware-configuration.nix
```

### Step 3: Apply Configuration

```bash
sudo nixos-rebuild switch --flake .#mylaptop   # or .#homepc, or .#myserver
```

## 3. macOS (nix-darwin) — Fresh Installation

Run **on the Mac**. Requirements: Mac username must be `vd`, and the repo must
be cloned to `~/nixos-config` (both are hardcoded via `repoRoot` / Home Manager).
Apple Silicon is assumed (`aarch64-darwin`; use `"x86_64-darwin"` on Intel).

### Step 1: Prerequisites

```bash
xcode-select --install

# Determinate Nix installer (flakes pre-enabled, has an uninstaller)
curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install | sh -s -- --daemon
```

### Step 2: Get the Configuration

```bash
git clone git@github.com:lvdund/nixos-config.git ~/nixos-config
cd ~/nixos-config
```

### Step 3: Bootstrap (installs nix-darwin itself)

```bash
sudo nix run nix-darwin/nix-darwin-26.05#darwin-rebuild -- switch --flake .#macvd
```

With the official nixos.org installer instead of Determinate, flakes are not
enabled yet — prefix the command with
`nix --extra-experimental-features 'nix-command flakes' run ...`
(your config enables them permanently after the first switch).

```bash
sudo nix run nix-darwin/nix-darwin-26.05#darwin-rebuild --extra-experimental-features "nix-command flakes" -- switch --flake .#macvd
```

### Step 4: Daily Use

After the first switch, `darwin-rebuild` is in `PATH`:

```bash
sudo darwin-rebuild switch --flake ~/nixos-config#macvd   # apply changes
sudo darwin-rebuild build --flake ~/nixos-config#macvd    # preview only
sudo darwin-rebuild --rollback                              # revert

sudo nix run nix-darwin#darwin-uninstaller                  # remove nix-darwin
```

Notes:

- The first switch "takes over" Nix management, sets fish as login shell,
  enables Touch ID / Apple Watch sudo, and Home Manager renames any conflicting
  pre-existing files to `*.backup` — review those afterwards.
- `system.stateVersion = 7` is pinned for a fresh nix-darwin-26.05 install;
  never bump it without reading `darwin-rebuild changelog`.

## 4. Maintenance (all hosts)

```bash
# Update all inputs (affects every host — review carefully)
nix flake update

# Linux: clean up old generations
sudo nix-collect-garbage -d
sudo nix-store --optimize

# macOS: garbage-collect on a schedule via launchd (see darwin/macvd/configuration.nix)
```

## 5. Git Configuration

Git identity is managed declaratively by Home Manager for all hosts in
**`users/modules/git.nix`** (`lvdund <lvdund@gmail.com>`) — change it there,
not with `git config --global`.

Only needed once per machine so git trusts the repo checkout:

```bash
git config --global --add safe.directory /etc/nixos/nixos-config   # Linux
git config --global --add safe.directory ~/nixos-config            # macOS
```

## 6. Manual Tooling Setup

Not (yet) covered by Nix — run once per user:

- Go tools:

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

## 7. Misc: Create a USB Boot Stick

```bash
# be careful that dd will destroy all data in sdb
sudo dd bs=4M if=archlinux-2026.08.01-x86_64.iso of=/dev/sdb conv=fsync oflag=direct status=progress
```
