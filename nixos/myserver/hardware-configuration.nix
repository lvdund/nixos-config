# Placeholder hardware configuration.
#
# Replace this file with the real one generated ON the server:
#   sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix
{
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };
}
