{
  config,
  pkgs,
  lib,
  ...
}: {
  boot.initrd.kernelModules = ["nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm"];
  security.pam.services.swaylock = {};

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd 'sway --unsupported-gpu'";
        user = "greeter";
      };
    };
  };
  environment.systemPackages = with pkgs; [
    wl-clipboard
    mako
    xwayland
    waybar
    grim # screenshot tool
    slurp # area selection for grim
    swayidle # idle management daemon
    swaylock-effects # screen lock with effects
    psmisc # proc filesystem
  ];

  programs = {
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      extraOptions = ["--unsupported-gpu"];
    };

    nix-ld.enable = true;
    nix-ld.libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
      fuse3
      icu
      zlib
      nss
      openssl
      curl
      expat
    ];
    appimage = {
      enable = true;
      binfmt = true;
    };
    light.enable = true;
  };

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    GBM_BACKEND = "nvidia-drm";
    NIXOS_OZONE_WL = "1";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  # xdg portal + pipewire = screensharing
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
    config.common.default = "*";
  };
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
  services.upower.enable = true;
}
