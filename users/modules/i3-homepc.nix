{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # picom
    # for popup calender
    yad
    xdotool
  ];

  # Link your custom configs
  home.file = {
    ".config/i3".source = config.lib.file.mkOutOfStoreSymlink "/tmp/nixos-config/config/i3-homepc";
    ".config/polybar".source = config.lib.file.mkOutOfStoreSymlink "/tmp/nixos-config/config/polybar";
    ".config/dunst".source = config.lib.file.mkOutOfStoreSymlink "/tmp/nixos-config/config/dunst";
    ".config/rofi".source = config.lib.file.mkOutOfStoreSymlink "/tmp/nixos-config/config/rofi";
    ".config/wallpapers".source = config.lib.file.mkOutOfStoreSymlink "/tmp/nixos-config/config/wallpapers";
  };
}
