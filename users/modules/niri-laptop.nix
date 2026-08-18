{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    brightnessctl
    networkmanagerapplet
    rofi
    thunar
    waybar
  ];

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
  };

  home.file = {
    ".config/niri".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/nixos-config/config/niri-laptop";
    ".config/waybar".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/nixos-config/config/waybar-laptop";
    ".config/fish".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/nixos-config/config/fish-sway";
    ".config/rofi".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/nixos-config/config/rofi";
  };
}
