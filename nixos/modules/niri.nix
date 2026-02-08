{ pkgs, inputs, lib, ... }:

{
  imports = [
    inputs.niri-flake.nixosModules.niri
  ];

  nixpkgs.overlays = [
    inputs.niri-flake.overlays.niri
  ];

  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };

  # Disable built-in polkit agent if using another one
  security.polkit.enable = true;
  systemd.user.services.niri-flake-polkit.enable = false;

  # Display Manager (greetd + regreet)
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.cage}/bin/cage -s -- ${pkgs.regreet}/bin/regreet";
      };
    };
  };
  programs.regreet.enable = true;

  # XDG Portals
  xdg.portal = {
    enable = true;
    config = {
      common = {
        default = [ "gtk" "wlr" ];
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
        "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
      };
    };
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];
  };

  # Swaylock PAM
  security.pam.services.swaylock = { };

  # System packages needed for Niri
  environment.systemPackages = with pkgs; [
    wl-clipboard
    gnome-keyring
  ];

  environment.pathsToLink = [
    "/share/xdg-desktop-portal"
    "/share/applications"
  ];
}
