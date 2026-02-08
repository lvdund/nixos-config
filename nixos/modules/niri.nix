{
  config,
  pkgs,
  ...
}: {
  programs.niri.enable = true;
  services.xserver.enable = false; # We don't need X
  programs.wayland.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gnome];
    config.common.default = "*";
  };
  environment.systemPackages = with pkgs; [
    fuzzel
    waybar
    mako
    grim # Screenshots
    slurp # Select screen area
    wl-clipboard # Clipboard
    swaybg # Wallpaper
  ];

  # Enable sound (PipeWire)
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

  # Fcitx5 environment variables
  environment.sessionVariables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    SDL_IM_MODULE = "fcitx";
    # GLFW_IM_MODULE = "ibus";
  };
}
