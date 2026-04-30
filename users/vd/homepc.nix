{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../modules/obs.nix
    ../modules/browser.nix
    ../modules/fish.nix
    ../modules/yazi.nix
    ../modules/tmux.nix
    ../modules/direnv.nix
    ../modules/i3.nix
    ../modules/code.nix
    ../modules/office.nix
    ../modules/steam.nix
  ];
  home.username = "vd";
  home.homeDirectory = "/home/vd";
  home.stateVersion = "25.11";

  systemd.user.sessionVariables = config.home.sessionVariables;

  # Packages for user
  home.packages = with pkgs; [
    protonup-qt
    pciutils
    parted
    gdu
    gparted
    sshfs
    file-roller
    openssl

    tor-browser
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
