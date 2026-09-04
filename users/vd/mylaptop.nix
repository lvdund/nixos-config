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
    ../modules/office.nix
    ../modules/git.nix
  ];
  home.username = "vd";
  home.homeDirectory = "/home/vd";
  home.stateVersion = "25.11";

  systemd.user.sessionVariables = config.home.sessionVariables;

  # Spawned by niri config.kdl at startup
  home.packages = with pkgs; [
    networkmanagerapplet
    cliphist
  ];

  # Link your custom configs (repoRoot comes from the flake's
  # home-manager.extraSpecialArgs)
  home.file = {
    ".config/kitty".source = config.lib.file.mkOutOfStoreSymlink "${repoRoot}/config/kitty";
    ".config/niri".source = config.lib.file.mkOutOfStoreSymlink "${repoRoot}/config/niri-laptop";
    ".config/waybar".source = config.lib.file.mkOutOfStoreSymlink "${repoRoot}/config/waybar-laptop";
  };

  programs = {
    home-manager.enable = true;
  };
}
