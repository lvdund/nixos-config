{
  config,
  pkgs,
  ...
}: {
  services.xserver = {
    enable = true;
    windowManager.i3.enable = true;
    displayManager = {
      defaultSession = "none+i3";
      lightdm.enable = true;
    };
    xkb.layout = "us";
  };

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
    i3
    i3status
    i3lock
    dmenu
    rofi
    acpi # For battery information
  ];

  programs = {
    i3lock.enable = true;
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
    appimage = {
      enable = true;
      binfmt = true;
    };
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
}
