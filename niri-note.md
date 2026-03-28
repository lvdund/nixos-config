
# Niri Setup Notes for NixOS

This document explains how niri compositor is configured in this NixOS config for reference in setting up your own.

---

## 1. Flake Input: niri-flake

Add the niri-flake input to your `flake.nix`:

```nix
{
  inputs = {
    niri-flake = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # ... other inputs
  };
}
```

## 2. Including niri NixOS Module

In your NixOS configuration, include the niri module:

```nix
# flake.nix - in nixosConfigurations
{
  nixosConfigurations.yourhostname = nixpkgs.lib.nixosSystem {
    modules = [
      niri-flake.nixosModules.niri
      # ... other modules
    ];
  };
}
```

## 3. Overlay for niri-unstable Package

Add the niri overlay to access `pkgs.niri-unstable`:

```nix
# system/packages/programs.nix (or wherever you configure nixpkgs)
{ pkgs, inputs, ... }:

{
  nixpkgs.overlays = [
    inputs.niri-flake.overlays.niri
  ];
}
```

## 4. Enable niri at System Level

Enable niri with the unstable package:

```nix
# system/packages/desktop.nix
{ pkgs, ... }:

{
  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };
}
```

## 5. Disable niri-flake's Built-in Polkit Service (Optional)

If you use your own polkit agent, disable the built-in one:

```nix
# system/core/security.nix
{ ... }:

{
  security.polkit.enable = true;
  systemd.user.services.niri-flake-polkit.enable = false;
}
```

---

## 6. Home Manager: Niri Configuration

The main niri config is done via Home Manager using `programs.niri.config`:

```nix
# sunny/desktop/niri.nix
{ pkgs, ... }:

let
  wallpaper = ../../assets/walls/japanese_pedestrian_street.jpg;
in
{
  # Enable stylix theming for niri (if using stylix)
  stylix.targets.niri.enable = true;

  # Niri configuration (KDL format as a string)
  programs.niri.config = ''
    input {
        keyboard {
            xkb {
                layout ""
                model ""
                rules ""
                variant ""
            }
            repeat-delay 600
            repeat-rate 25
            track-layout "global"
            numlock
        }
        touchpad {
            tap
            drag true
            natural-scroll
            scroll-method "two-finger"
            click-method "clickfinger"
        }
        mod-key "Super"
    }

    screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

    prefer-no-csd

    layout {
        gaps 12
        struts {
            left 0
            right 0
            top 0
            bottom 0
        }
        focus-ring {
            width 1
            urgent-color "#e67e80"
            active-color "#a7c080"
            inactive-color "9da9a0"
        }
        border { off; }
        tab-indicator {
            gap 5.0
            width 4.0
            length total-proportion=0.5
            position "left"
            gaps-between-tabs 0.0
            corner-radius 0.0
        }
        insert-hint { color "#161616"; }
        default-column-width { proportion 0.5; }
        preset-column-widths {
            proportion 0.333333
            proportion 0.5
            proportion 0.666667
        }
        preset-window-heights {
            proportion 0.333333
            proportion 0.5
            proportion 0.666667
        }
        center-focused-column "never"
    }

    cursor {
        xcursor-theme "everforest-cursors"
        xcursor-size 24
    }

    hotkey-overlay { skip-at-startup; }

    environment {
        "CLUTTER_BACKEND" "wayland"
        "GDK_BACKEND" "wayland"
        "NIXOS_OZONE_WL" "1"
        "QT_AUTO_SCREEN_SCALE_FACTOR" "1"
        "QT_QPA_PLATFORM" "wayland"
        "QT_QPA_PLATFORMTHEME" "qtct"
        "QT_STYLE_OVERRIDE" "kvantum"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION" "1"
        "SDL_VIDEODRIVER" "wayland"
        "_JAVA_AWT_WM_NONREPARENTING" "1"
    }

    spawn-at-startup "${pkgs.pantheon.pantheon-agent-polkit}/libexec/policykit-1-pantheon/io.elementary.desktop.agent-polkit"
    spawn-sh-at-startup "${pkgs.swww}/bin/swww img ${wallpaper} --transition-duration 0.5"

    binds {
        Mod+T { spawn "foot"; }
        Mod+A { spawn "rofi" "-show" "drun"; }
        Mod+Q { close-window; }
        Mod+F { maximize-column; }
        Mod+Shift+F { fullscreen-window; }
        Mod+V { toggle-window-floating; }
        
        // Workspace switching
        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        // ... etc
        
        // Volume/brightness (allow when locked)
        XF86AudioLowerVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"; }
        XF86AudioRaiseVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"; }
        XF86MonBrightnessDown allow-when-locked=true { spawn "${pkgs.brightnessctl}/bin/brightnessctl" "set" "5%-"; }
        XF86MonBrightnessUp allow-when-locked=true { spawn "${pkgs.brightnessctl}/bin/brightnessctl" "set" "5%+"; }
        
        // Lock screen
        Mod+Alt+L allow-when-locked=true { spawn "swaylock"; }
        
        // Screenshots
        Print { screenshot; }
        Alt+Print { screenshot-window; }
        Ctrl+Print { screenshot-screen; }
    }

    // Window rules
    window-rule {
        draw-border-with-background false
        geometry-corner-radius 4.0 4.0 4.0 4.0
        clip-to-geometry true
    }
    window-rule {
        match is-active=true
        opacity 0.9
    }
    window-rule {
        match is-active=false
        opacity 0.8
    }
    window-rule {
        match app-id="^firefox$" title="^Picture-in-Picture$"
        open-floating true
    }

    layer-rule {
        match namespace="^wallpaper$"
        place-within-backdrop true
    }

    gestures { hot-corners { off; }; }
  '';
}
```

---

## 7. XWayland Support

For X11 app compatibility, install xwayland-satellite:

```nix
# In home.packages
home.packages = with pkgs; [
  xwayland-satellite-unstable
];
```

---

## 8. Services Configuration

### 8.1 Waybar (Status Bar)

Waybar is configured via a systemd user service that detects the compositor:

```nix
# sunny/desktop/waybar.nix
{ config, pkgs, ... }:

let
  waybarConfigDir = "${config.home.homeDirectory}/.config/waybar";
in
{
  services.playerctld.enable = true;
  programs.waybar.enable = true;

  systemd.user.services.waybar = {
    Unit = {
      Description = "Waybar status bar";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = pkgs.writeShellScript "waybar-launch" ''
        compositor="''${XDG_CURRENT_DESKTOP:-unknown}"
        case "''$compositor" in
          niri)
            cfg="${waybarConfigDir}/config-niri"
            ;;
          *)
            cfg="${waybarConfigDir}/config"
            ;;
        esac
        exec ${pkgs.waybar}/bin/waybar --config "''$cfg" --style "${waybarConfigDir}/style.css"
      '';
      Restart = "on-failure";
      RestartSec = 2;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  # Waybar config for niri (uses "niri/workspaces" module)
  xdg.configFile."waybar/config-niri".text = ''
    [
    {
      "modules-left": ["image", "niri/workspaces", "wlr/taskbar"],
      "niri/workspaces": {
        "all-outputs": true,
        "format": "{icon}",
        "format-icons": {
          "1": "1", "2": "2", "3": "3", ...
        }
      },
      ...
    }
    ]
  '';
}
```

**Key Point**: Niri has native waybar support via the `niri/workspaces` module.

### 8.2 Mako (Notifications)

```nix
services.mako = {
  enable = true;
  settings = {
    border-size = 1;
    default-timeout = 10000;
  };
};
```

### 8.3 Cliphist (Clipboard Manager)

```nix
services.cliphist = {
  enable = true;
  allowImages = true;
  systemdTargets = [ "graphical-session.target" ];
};
```

### 8.4 Swww (Wallpaper)

```nix
services.swww.enable = true;
# Then in niri config: spawn-sh-at-startup for setting wallpaper
```

### 8.5 Swaylock (Screen Lock)

System-level PAM config required:

```nix
# system/packages/swaylock.nix
{ ... }:
{
  security.pam.services.swaylock = { };
}
```

Home Manager config:

```nix
programs.swaylock = {
  enable = true;
  settings = {
    daemonize = true;
    ignore-empty-password = true;
    font-size = 14;
  };
};
```

### 8.6 Swayidle (Idle Management)

Custom systemd service that adapts to the compositor:

```nix
systemd.user.services.swayidle = {
  Unit = {
    Description = "swayidle";
    PartOf = [ "graphical-session.target" ];
    After = [ "graphical-session.target" ];
  };
  Service = {
    ExecStart = pkgs.writeShellScript "swayidle-launch" ''
      compositor="''${XDG_CURRENT_DESKTOP:-unknown}"
      case "''${compositor}" in
        niri)
          exec ${pkgs.swayidle}/bin/swayidle -w \
            timeout 300 '${pkgs.swaylock}/bin/swaylock -fF' \
            timeout 600 'niri msg action power-off-monitors' \
            resume 'niri msg action power-on-monitors'
          ;;
        *)
          exec ${pkgs.swayidle}/bin/swayidle -w \
            timeout 600 'echo "Idle timeout"'
          ;;
      esac
    '';
    Restart = "on-failure";
  };
  Install = {
    WantedBy = [ "graphical-session.target" ];
  };
};
```

### 8.7 Wayland Pipewire Idle Inhibit

Prevents idle when audio is playing:

```nix
# Requires the flake input
services.wayland-pipewire-idle-inhibit = {
  enable = true;
  package = "${pkgs.wayland-pipewire-idle-inhibit}";
  systemdTarget = "graphical-session.target";
  settings = {
    verbosity = "INFO";
    media_minimum_duration = 10;
    idle_inhibitor = "wayland";
  };
};
```

---

## 9. XDG Desktop Portals

Configure portals for screen sharing, file dialogs, etc:

```nix
# system/packages/portals.nix
{ pkgs, ... }:

{
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
}
```

---

## 10. Rofi (Application Launcher)

```nix
programs.rofi = {
  enable = true;
  cycle = true;
  modes = [ "drun" "window" "run" "filebrowser" ];
  terminal = "${pkgs.foot}/bin/footclient";
};
```

### Power Menu Script for Niri

Create a script that uses niri IPC for logout:

```bash
# Key difference from sway: use "niri msg action quit --skip-confirmation"
actions[logout]="niri msg action quit --skip-confirmation"
```

---

## 11. Display Manager: greetd + regreet

```nix
# system/packages/desktop.nix
{ pkgs, ... }:

{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.cage}/bin/cage -s -- ${pkgs.regreet}/bin/regreet";
      };
    };
  };
  programs.regreet.enable = true;
}
```

---

## 12. Niri-Specific Helper Scripts

### Color Picker

```nix
home.packages = [
  (writeShellScriptBin "niri-color-picker" ''
    niri msg pick-color | awk '$1 == "Hex:" { printf "%s", $2 }' | wl-copy
  '')
];
```

### Reload Waybar for Niri

```nix
home.packages = [
  (writeShellScriptBin "reload-waybar-niri" ''
    if pgrep -x "waybar" > /dev/null; then
      pkill -x "waybar"
    fi
    sleep 1
    waybar -c $HOME/.config/waybar/config-niri
  '')
];
```

---

## 13. Input Method Configuration

**NOTE**: This config does NOT have input method (fcitx5/ibus) configuration. If you need CJK input, add:

```nix
# System level
i18n.inputMethod = {
  enable = true;
  type = "fcitx5";
  fcitx5.addons = with pkgs; [
    fcitx5-mozc      # Japanese
    fcitx5-hangul    # Korean
    fcitx5-chinese-addons  # Chinese
  ];
};

# Add to niri environment block:
environment {
    "GTK_IM_MODULE" "fcitx"
    "QT_IM_MODULE" "fcitx"
    "XMODIFIERS" "@im=fcitx"
    # ... other env vars
}

# Start fcitx5 with niri:
spawn-at-startup "fcitx5" "-d"
```

---

## 14. Essential System Packages

```nix
environment.systemPackages = with pkgs; [
  wl-clipboard      # Clipboard for Wayland
  gnome-keyring     # Secret storage
  # ... etc
];

environment.pathsToLink = [
  "/share/xdg-desktop-portal"
  "/share/applications"
];
```

---

## Summary: File Structure

```
flake.nix                           # niri-flake input + nixosModules.niri
system/
  core/
    security.nix                    # polkit, disable niri-flake-polkit
  packages/
    desktop.nix                     # programs.niri.enable, greetd
    programs.nix                    # niri-flake overlay
    portals.nix                     # XDG portals
    swaylock.nix                    # PAM config
sunny/
  home.nix                          # imports desktop/niri.nix
  desktop/
    niri.nix                        # programs.niri.config, spawn-at-startup
    services.nix                    # mako, cliphist, swww, swayidle, idle-inhibit
    waybar.nix                      # waybar config + systemd service
    foot.nix                        # terminal
  rofi/
    rofi.nix                        # launcher config
    scripts.nix                     # power menu scripts
    rofi-power-menu-niri            # script using "niri msg action"
  packages/
    packages.nix                    # helper scripts like niri-color-picker
```

---

## Key Niri IPC Commands

```bash
niri msg action quit --skip-confirmation  # Logout
niri msg action power-off-monitors        # Turn off displays
niri msg action power-on-monitors         # Turn on displays
niri msg pick-color                       # Color picker
```

---

## Quick Checklist for Your Setup

- [ ] Add `niri-flake` to flake inputs
- [ ] Include `niri-flake.nixosModules.niri` in modules
- [ ] Add `niri-flake.overlays.niri` to nixpkgs overlays
- [ ] Enable `programs.niri` at system level
- [ ] Configure `programs.niri.config` in Home Manager
- [ ] Set up XDG portals (gtk + wlr)
- [ ] Configure PAM for swaylock
- [ ] Set up waybar with `niri/workspaces` module
- [ ] Configure display manager (greetd recommended)
- [ ] Add Wayland environment variables in niri config
- [ ] (Optional) Configure input methods with proper env vars
