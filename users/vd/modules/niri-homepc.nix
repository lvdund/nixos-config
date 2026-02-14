{
  pkgs,
  config,
  ...
}: {
  # Niri config is managed via symlink (config/niri/)
  # System-level niri is enabled via nixos/modules/niri.nix
  # This module handles companion tools (waybar, mako, swaylock, etc.)

  home.packages = with pkgs; [
    xwayland-satellite-unstable
    rofi # config managed via symlink
    swayidle
    wayland-pipewire-idle-inhibit
    wlogout
    libnotify
    mako
    wl-clipboard
    cliphist
    grim
    slurp
    blueman
    cava
    playerctl
  ];

  # Waybar (Status Bar)
  programs.waybar = {
    enable = true;
    systemd.enable = false;
  };

  # Link config directory
  # xdg.configFile."waybar".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/config/waybar";
  # xdg.configFile."niri".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/config/niri";
  # xdg.configFile."rofi".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/config/rofi";
  # xdg.configFile."wallpapers".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/config/wallpapers";

  home.file = {
    "waybar".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/config/waybar";
    "niri".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/config/niri-homepc";
    "rofi".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/config/rofi";
    "wallpapers".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/config/wallpapers";
  };

  # Mako (Notifications)
  services.mako = {
    enable = true;
    settings = {
      default-timeout = 5000;
      border-size = 2;
      border-radius = 5;
      background-color = "#1e1e2e";
      border-color = "#89b4fa";
      text-color = "#cdd6f4";
      font = "FiraCode Nerd Font 12";
    };
  };

  # Cliphist (Clipboard Manager)
  services.cliphist = {
    enable = true;
    allowImages = true;
    systemdTargets = ["graphical-session.target"];
  };

  # Swaylock (Screen Lock)
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      daemonize = true;
      ignore-empty-password = true;
      font = "FiraCode Nerd Font";
      font-size = 20;
      indicator-idle-visible = false;
      indicator-radius = 100;
      show-failed-attempts = true;
    };
  };

  # Wallpaper daemon
  services.swww.enable = true;

  # Swayidle (Idle Management)
  # services.swayidle = {
  #   enable = true;
  #   systemdTarget = "graphical-session.target";
  #   events = [
  #     { event = "before-sleep"; command = "${pkgs.swaylock-effects}/bin/swaylock -fF"; }
  #     { event = "lock"; command = "${pkgs.swaylock-effects}/bin/swaylock -fF"; }
  #   ];
  #   timeouts = [
  #     { timeout = 300; command = "${pkgs.swaylock-effects}/bin/swaylock -fF"; }
  #     { timeout = 600; command = "niri msg action power-off-monitors"; resumeCommand = "niri msg action power-on-monitors"; }
  #   ];
  # };
}
