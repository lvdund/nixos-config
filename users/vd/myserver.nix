{
  repoRoot ? "/etc/nixos/nixos-config",
  config,
  pkgs,
  ...
}: {
  imports = [
    # Headless user modules only — no niri/browser/office
    ../modules/nvim.nix
    ../modules/fish.nix
    ../modules/direnv.nix
    ../modules/git.nix
  ];
  home.username = "vd";
  home.homeDirectory = "/home/vd";
  # Fresh install from the 26.05 flake — pin at first install, never bump
  home.stateVersion = "26.05";

  systemd.user.sessionVariables = config.home.sessionVariables;

  programs = {
    home-manager.enable = true;
  };
}
