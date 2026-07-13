{
  config,
  pkgs,
  lib,
  ...
}: {
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd 'sway --unsupported-gpu'";
      user = "greeter";
    };
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    xwayland.enable = true;
  };

  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-wlr];

  services.gvfs.enable = true;
  services.tumbler.enable = true;

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

  environment.systemPackages = with pkgs; [
    tuigreet
  ];

  environment.sessionVariables = {
    GBM_BACKEND = "nvidia-drm";
    LIBVA_DRIVER_NAME = "nvidia";
    NIXOS_OZONE_WL = "1";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  programs = {
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
  };

  security.polkit.enable = true;

  # Sway handles refresh and output state directly, so avoid X11 session hooks.
  services.xserver.displayManager.sessionCommands = lib.mkForce "";
}
