{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    # inputs.niri-flake.homeModules.niri
    ./modules/obs.nix
    ./modules/brave.nix
    ./modules/fish.nix
    ./modules/yazi.nix
    ./modules/tmux.nix
    ./modules/direnv.nix
    ./modules/niri-homepc.nix
    ./modules/code.nix
    ./modules/office.nix
  ];
  home.username = "vd";
  home.homeDirectory = "/home/vd";
  home.stateVersion = "25.11";

  # Packages for user
  home.packages = with pkgs; [
    wpsoffice
    protonup-qt
    vscode
    pciutils
    parted
    gdu
    gparted
    sshfs
    file-roller
    openssl
  ];

  # Link your custom configs
  home.file = {
    ".config/kitty".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/config/kitty";
    ".config/zathura".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/config/zathura";
  };

  programs = {
    home-manager.enable = true;
  };
}
