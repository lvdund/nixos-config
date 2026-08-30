{
  config,
  pkgs,
  ...
}: {
  programs = {
    niri = {
      enable = true;
      useNautilus = false;
    };
    xwayland.enable = true;
    waybar.enable = true;
    appimage = {
      enable = true;
      binfmt = true;
    };
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc.lib
        zlib
        fuse3
        icu
        nss
        openssl
        curl
        expat
      ];
    };
  };

  # Mesa / OpenGL (no NVIDIA settings here; homepc adds ../nvidia.nix)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  security.polkit.enable = true;
  security.pam.services.swaylock = {};

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

  services.gvfs.enable = true;
  services.tumbler.enable = true;

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd '${config.programs.niri.package}/bin/niri-session'";
      user = "greeter";
    };
  };

  xdg.portal.config.niri = {
    "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.systemPackages = with pkgs; [
    tuigreet
    fuzzel
    mako
    swaylock
    thunar
    file-roller
    playerctl
    wl-clipboard
    grim
    satty
    slurp
    brightnessctl
    pavucontrol
    libnotify
    lxqt.lximage-qt

    adwaita-icon-theme
  ];
}
