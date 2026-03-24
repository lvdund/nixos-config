{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    rofi
    # for popup calender
    # yad
    # xdotool
  ];

  # Link your custom configs
  home.file = {
    ".config/sway".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/config/sway";
    ".config/wallpapers".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/config/wallpapers";
    ".config/rofi".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/config/rofi";
    ".config/waybar".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/config/waybar-homepc";
  };
}
