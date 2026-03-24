{pkgs, ...}: {
  # Environment variables for Steam
  # Note: Steam itself is configured at NixOS system level in nixos/modules/i3.nix
  home.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
  };
  home.packages = with pkgs; [steam];
}
