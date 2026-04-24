{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../modules/browser.nix
    ../modules/fish.nix
    ../modules/yazi.nix
    ../modules/tmux.nix
    ../modules/direnv.nix
    ../modules/i3.nix
    ../modules/code.nix
  ];
  home.username = "lab";
  home.homeDirectory = "/home/lab";
  home.stateVersion = "25.11";

  systemd.user.sessionVariables = config.home.sessionVariables;

  # Packages for user
  home.packages = with pkgs; [
    pciutils
    gdu
    sshfs
    file-roller
    openssl
  ];

  # Link your custom configs
  home.file = {
    ".config/kitty".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/nixos-config/config/kitty";
    ".config/zathura".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/nixos-config/config/zathura";
  };

  programs = {
    home-manager.enable = true;
  };
}
