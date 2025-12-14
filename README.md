# NixOS Configuration Notes

## Initial Setup

### Copy Hardware Configuration

Copy the hardware configuration from your system to the project:

```bash
sudo cp /etc/nixos/hardware-configuration.nix .
```

This file contains hardware-specific settings (disk partitions, filesystems, etc.) that are unique to your machine.

## Applying Configuration

### Build and Apply NixOS Configuration

To build and apply your NixOS configuration:

```bash
# From the project directory
cd /home/vd/temp/nixos-config

# Build and switch to the new configuration
sudo nixos-rebuild switch --flake .#homepc

# Or if you want to test first without applying:
sudo nixos-rebuild build --flake .#homepc
sudo nixos-rebuild test --flake .#homepc  # Test without making it permanent
```

### Update Flake Lock File

When you modify inputs or want to update packages:

```bash
nix flake update
```

## Development Environments

### Go Development Environments

#### Available Go Shells

- `go-1-24` - Go 1.24 environment
- `default` - Default Go environment (currently Go 1.24)

#### Entering a Go Development Shell

```bash
# Enter Go 1.24 environment
nix develop .#go-1-24

# Or use the default
nix develop

# Or use nix-shell (if not using flakes)
nix-shell -p go
```

#### Using Go in the Shell

Once inside the shell:

```bash
# Check Go version
go version

# Check environment variables
echo $GOPATH
echo $GOROOT

# Your GOPATH is isolated per version: ~/env/go_1.24
# Create a new project
mkdir -p $GOPATH/src/myproject
cd $GOPATH/src/myproject

# Initialize a Go module
go mod init myproject

# Build and run
go build
go run main.go
```

### Python Development Environments

#### Available Python Shells

- `python-3-13` - Python 3.13 environment

#### Entering a Python Development Shell

```bash
# Enter Python 3.13 environment
nix develop .#python-3-13
```

#### Using Python in the Shell

Once inside the shell:

```bash
# Check Python version
python --version

# Install packages to isolated location (~/env/python_3.13)
pip install --user <package-name>

# Or create a virtual environment
python -m venv .venv
source .venv/bin/activate
```

## Project Structure

```
nixos-config/
├── flake.nix              # Main flake configuration
├── configuration.nix      # NixOS system configuration
├── home.nix               # Home Manager user configuration
├── hardware-configuration.nix  # Hardware-specific config (copy from /etc/nixos)
├── NOTES.md               # This file
└── config/                # User configuration files
    ├── i3/                # i3 window manager config
    ├── nvim/              # Neovim config
    ├── rofi/              # Rofi launcher config
    └── ...
```

## Useful Commands

### Check Current Configuration

```bash
# See what would be built
nix flake show

# Check for configuration errors
nix flake check
```

### Rollback Configuration

If something goes wrong:

```bash
# Rollback to previous generation
sudo nixos-rebuild switch --rollback

# Or list generations and switch to a specific one
sudo nix-env --list-generations -p /nix/var/nix/profiles/system
sudo nixos-rebuild switch --upgrade
```

### Garbage Collection

Clean up unused packages:

```bash
# Remove unused packages
nix-collect-garbage -d

# Remove old generations (keep last 3)
sudo nix-collect-garbage --delete-older-than 7d
```

## Troubleshooting

### Flake Lock Issues

If you get lock file errors:

```bash
# Regenerate lock file
nix flake lock --update-input nixpkgs
```

### Build Failures

If a build fails:

```bash
# Get more detailed error information
nixos-rebuild build --flake .#homepc --show-trace

# Check for broken packages
nix flake check --show-trace
```

## Notes

- The Go environments use isolated GOPATH directories in `~/env/go_<version>/`
- Python environments use isolated pip install locations in `~/env/python_<version>/`
- Desktop notifications are sent when entering development shells (if `notify-send` is available)
- All user configurations are symlinked from `config/` to `~/.config/` via Home Manager
