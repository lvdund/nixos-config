{
  repoRoot ? "/etc/nixos/nixos-config",
  config,
  pkgs,
  ...
}: {
  imports = [
    ../modules/nvim.nix
    ../modules/fish.nix
    ../modules/direnv.nix
    ../modules/niri.nix
    ../modules/browser.nix
    ../modules/game.nix
    ../modules/office.nix
    ../modules/git.nix
  ];
  home.username = "vd";
  home.homeDirectory = "/home/vd";
  home.stateVersion = "25.11";

  systemd.user.sessionVariables = config.home.sessionVariables;

  # NVIDIA debugging
  home.packages = with pkgs; [
    pciutils
  ];

  # Link your custom configs (repoRoot comes from the flake's
  # home-manager.extraSpecialArgs)
  home.file = {
    ".config/kitty".source = config.lib.file.mkOutOfStoreSymlink "${repoRoot}/config/kitty";
    ".config/niri".source = config.lib.file.mkOutOfStoreSymlink "${repoRoot}/config/niri";
    ".config/waybar".source = config.lib.file.mkOutOfStoreSymlink "${repoRoot}/config/waybar";
  };

  programs = {
    home-manager.enable = true;
  };
}
