{ config, pkgs, ... }:

{
  home.username = "vd";
  home.homeDirectory = "/home/vd";
  home.stateVersion = "25.11";

  # Environment variables
  home.sessionVariables.MOZ_ENABLE_WAYLAND = "0";

  # Packages for user
  home.packages = with pkgs; [
  ];

  # i3 configuration
  xsession.windowManager.i3 = {
    enable = true;
    config = null; # We'll use your custom config
  };

  # Link your custom configs
  home.file = {
    ".config/i3" = {
      source = ./config/i3;
      recursive = true;
      force = true;
    };
    ".config/i3status" = {
      source = ./config/i3status;
      recursive = true;
      force = true;
    };
    ".config/rofi" = {
      source = ./config/rofi;
      recursive = true;
      force = true;
    };
    ".config/dunst" = {
      source = ./config/dunst;
      recursive = true;
      force = true;
    };
    ".config/kitty" = {
      source = ./config/kitty;
      recursive = true;
      force = true;
    };
    ".config/nvim" = {
      source = ./config/nvim;
      recursive = true;
      force = true;
    };
    ".config/Thunar" = {
      source = ./config/Thunar;
      recursive = true;
      force = true;
    };
  };

  # Fish shell
  programs.fish.enable = true;

  # Firefox
  programs.firefox = {
    enable = true;
    languagePacks = [ "en-US" "vn" ];
    policies = {
      BlockAboutConfig = true;
      DefaultDownloadDirectory = "\${home}/Downloads";
      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          default_area = "menupanel";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
        };
      };
    };
  };
  programs.chromium = {
    enable = true;
    package = pkgs.brave;
    commandLineArgs = [
      "--disable-features=WebRtcAllowInputVolumeAdjustment"
    ];
  };

  # Let home-manager manage itself
  programs.home-manager.enable = true;
}
