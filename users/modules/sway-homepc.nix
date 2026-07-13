{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    adwaita-icon-theme
    dex
    grim
    jq
    slurp
    mako
    networkmanagerapplet
    playerctl
    rofi
    swaybg
    swayidle
    swaylock
    waybar
    wl-clipboard
  ];

  home.file = {
    ".config/mako".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/nixos-config/config/mako";
    ".config/rofi".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/nixos-config/config/rofi";
    ".config/sway".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/nixos-config/config/sway";
    ".config/waybar".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/nixos-config/config/waybar";
    ".config/wallpapers".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/nixos-config/config/wallpapers";
  };
}
