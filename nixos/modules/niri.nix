{
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.niri-flake.nixosModules.niri
  ];

  nixpkgs.overlays = [
    inputs.niri-flake.overlays.niri
  ];

  programs = {
    niri = {
      enable = true;
      package = pkgs.niri-unstable;
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
  };

  # Register niri as a session package
  services.displayManager.sessionPackages = [pkgs.niri-unstable];

  # Polkit agent provided by niri-flake (using KDE agent)
  security.polkit.enable = true;
  systemd.user.services.niri-flake-polkit = {
    description = "PolicyKit Authentication Agent provided by niri-flake";
    wantedBy = ["niri.service"];
    after = ["graphical-session.target"];
    partOf = ["graphical-session.target"];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  # Display Manager (greetd + regreet)
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.cage}/bin/cage -s -- ${pkgs.regreet}/bin/regreet";
      };
    };
  };
  programs.regreet = {
    enable = true;
    settings = {
      background = {
        path = ../../config/wallpapers/anya.png;
        fit = "Cover";
      };
      GTK = {
        application_prefer_dark_theme = true;
        theme_name = lib.mkForce "Adwaita-dark";
      };
    };
    theme = {
      package = pkgs.gnome-themes-extra;
      name = "Adwaita-dark";
    };
    extraCss = ''
      window {
        background-color: #282828;
      }
      .login-box {
        background-color: rgba(40, 40, 40, 0.9);
        border: 2px solid #d79921;
        border-radius: 10px;
        padding: 20px;
        color: #ebdbb2;
      }
      entry {
        background-color: #3c3836;
        color: #ebdbb2;
        border: 1px solid #a89984;
      }
      label {
        color: #ebdbb2;
      }
    '';
  };

  # XDG Portals
  xdg.portal = {
    enable = true;
    config = lib.mkForce {
      common = {
        default = ["gtk" "wlr"];
        "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
        "org.freedesktop.impl.portal.ScreenCast" = ["wlr"];
        "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
      };
    };
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
    configPackages = [pkgs.niri-unstable];
  };

  # Swaylock PAM
  security.pam.services.swaylock = {};

  # System packages needed for Niri
  environment.systemPackages = with pkgs; [
    wl-clipboard
    gnome-keyring
    xdg-utils
    gnome-themes-extra
  ];

  environment.pathsToLink = [
    "/share/xdg-desktop-portal"
    "/share/applications"
  ];
}
