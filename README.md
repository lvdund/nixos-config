# NixOS Configuration

## 1. Git Configuration

Set up your global git identity:

```bash
git config --global user.email "lvdund@gmail.com"
git config --global user.name "lvdund"
```

## 2. Go Tools Setup

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

## 3. NixOS Maintenance

### Build and Apply Changes

To build the configuration and switch to it immediately:

```bash
# Apply configuration
sudo nixos-rebuild switch --flake .#homepc
```

To build and test without modifying the bootloader (good for temporary checks):

```bash
# Test configuration
sudo nixos-rebuild test --flake .#homepc
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