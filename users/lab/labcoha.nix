{
  config,
  pkgs,
  lib,
  ...
}: {
  home.username = "lab";
  home.homeDirectory = "/home/lab";
  home.stateVersion = "25.11";

  imports = [
    ../modules/browser.nix
    ../modules/fish.nix
    ../modules/yazi.nix
    ../modules/tmux.nix
    ../modules/direnv.nix
    ../modules/i3-homepc.nix
    ../modules/code.nix
    ../modules/office.nix
  ];

  home.packages = with pkgs; [
    pciutils
    gdu
    sshfs
    file-roller
    openssl
  ];

  home.file = {
    ".config/kitty".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/config/kitty";
    ".config/zathura".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/config/zathura";
  };

  programs = {
    home-manager.enable = true;
  };
}
