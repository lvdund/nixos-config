{
  config,
  pkgs,
  inputs,
  ...
}: {
  # Enable niri compositor
  programs.niri.enable = true;

  # Display manager configuration
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd niri-session";
        user = "greeter";
      };
    };
  };

  # File manager and related services
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  # Audio configuration (PipeWire)
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    jack.enable = false;
  };
  services.pulseaudio.enable = false;

  # XDG portal for Wayland
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
    ];
    config.niri = {
      default = ["gnome" "gtk"];
    };
  };

  # Noctalia Shell and related packages
  environment.systemPackages = with pkgs; [
    # Noctalia Shell - Wayland compositor shell
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    
    # Essential tools for niri
    fuzzel # App launcher (alternative to rofi/dmenu)
    swaylock # Screen locker
    mako # Notification daemon for Wayland
    grim # Screenshot tool for Wayland
    slurp # Region selection for screenshots
    wl-clipboard # Clipboard utilities for Wayland
    xwayland-satellite # XWayland support for niri
    
    # Terminal (for niri config compatibility)
    kitty # Terminal emulator
    
    # System utilities
    brightnessctl # Brightness control
    pavucontrol # Audio control
    
    # File manager
    nemo # File manager with good Wayland support
    
    # Theme and appearance
    tokyonight-gtk-theme
    rose-pine-cursor
    adwaita-icon-theme
    
    # Image viewer
    swayimg # Lightweight image viewer for Wayland
    
    # Additional Wayland tools
    wlr-randr # Display configuration
    waypipe # Network transparency for Wayland
  ];

  programs = {
    # nix-ld for unpatched binaries
    nix-ld.enable = true;
    nix-ld.libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
      fuse3
      icu
      nss
      openssl
      curl
      expat
    ];

    # File manager
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-media-tags-plugin
        thunar-volman
      ];
    };

    dconf.enable = true;
    xfconf.enable = true;

    # AppImage support
    appimage = {
      enable = true;
      binfmt = true;
    };

    # Gaming support
    gamescope = {
      enable = true;
      capSysNice = true;
    };
    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
    gamemode.enable = true;
  };

  # Environment variables for Wayland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # Enable Wayland for Electron/Chrome apps
    MOZ_ENABLE_WAYLAND = "1"; # Enable Wayland for Firefox
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };
}
