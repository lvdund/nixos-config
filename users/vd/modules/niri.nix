{ pkgs, config, lib, ... }:

let
  waybarConfigDir = "${config.home.homeDirectory}/.config/waybar";
in
{
  programs.niri.enable = true;
  programs.niri.package = pkgs.niri-unstable;

  home.packages = with pkgs; [
    xwayland-satellite-unstable
    foot
    rofi-wayland
    swaylock
    swayidle
    wayland-pipewire-idle-inhibit
    wlogout
    libnotify
    mako
    wl-clipboard
    cliphist
    grim
    slurp
  ];

  # Niri configuration (KDL format as a string)
  programs.niri.config = ''
    input {
        keyboard {
            xkb {
                layout "us"
                model ""
                rules ""
                variant ""
                options "grp:win_space_toggle,compose:ralt,ctrl:nocaps"
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
            width 2
            active-color "#7fc8ff"
            inactive-color "#505050"
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
        insert-hint { color "#7fc8ff"; }
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
        xcursor-theme "Adwaita"
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

    spawn-at-startup "${pkgs.xwayland-satellite-unstable}/bin/xwayland-satellite"

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
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+8 { focus-workspace 8; }
        Mod+9 { focus-workspace 9; }
        
        Mod+Shift+1 { move-column-to-workspace 1; }
        Mod+Shift+2 { move-column-to-workspace 2; }
        Mod+Shift+3 { move-column-to-workspace 3; }
        Mod+Shift+4 { move-column-to-workspace 4; }
        Mod+Shift+5 { move-column-to-workspace 5; }
        Mod+Shift+6 { move-column-to-workspace 6; }
        Mod+Shift+7 { move-column-to-workspace 7; }
        Mod+Shift+8 { move-column-to-workspace 8; }
        Mod+Shift+9 { move-column-to-workspace 9; }

        // Vim-like focus
        Mod+H { focus-column-left; }
        Mod+J { focus-window-down; }
        Mod+K { focus-window-up; }
        Mod+L { focus-column-right; }

        Mod+Shift+H { move-column-left; }
        Mod+Shift+J { move-window-down; }
        Mod+Shift+K { move-window-up; }
        Mod+Shift+L { move-column-right; }

        // Volume/brightness (allow when locked)
        XF86AudioLowerVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"; }
        XF86AudioRaiseVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"; }
        XF86AudioMute allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
        XF86MonBrightnessDown allow-when-locked=true { spawn "${pkgs.brightnessctl}/bin/brightnessctl" "set" "5%-"; }
        XF86MonBrightnessUp allow-when-locked=true { spawn "${pkgs.brightnessctl}/bin/brightnessctl" "set" "5%+"; }
        
        // Lock screen
        Mod+Alt+L allow-when-locked=true { spawn "swaylock"; }
        
        // Screenshots
        Print { screenshot; }
        Alt+Print { screenshot-window; }
        Ctrl+Print { screenshot-screen; }

        // Quit
        Mod+Shift+E { quit; }
        Ctrl+Alt+Delete { quit; }
    }

    // Window rules
    window-rule {
        draw-border-with-background false
        geometry-corner-radius 8.0 8.0 8.0 8.0
        clip-to-geometry true
    }
    window-rule {
        match is-active=true
        opacity 1.0
    }
    window-rule {
        match is-active=false
        opacity 0.95
    }
    window-rule {
        match app-id="^firefox$" title="^Picture-in-Picture$"
        open-floating true
    }

    gestures { hot-corners { off; }; }
  '';

  # Waybar (Status Bar)
  programs.waybar = {
    enable = true;
    systemd.enable = true;
  };
  
  systemd.user.services.waybar = {
    Unit = {
      Description = "Waybar status bar";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = pkgs.writeShellScript "waybar-launch" ''
        compositor="''${XDG_CURRENT_DESKTOP:-unknown}"
        waybarConfigDir="${waybarConfigDir}"
        case "''$compositor" in
          niri)
            cfg="''${waybarConfigDir}/config-niri"
            ;;
          *)
            cfg="''${waybarConfigDir}/config"
            ;;
        esac
        # Ensure directory exists or config exists before run
        # For now assume config-niri is generated by HM
        exec ${pkgs.waybar}/bin/waybar --config "''$cfg" --style "''${waybarConfigDir}/style.css"
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
      "layer": "top",
      "position": "top",
      "height": 30,
      "modules-left": ["niri/workspaces", "niri/window"],
      "modules-center": ["clock"],
      "modules-right": ["cpu", "memory", "network", "pulseaudio", "battery", "tray"],
      "niri/workspaces": {
        "all-outputs": true,
        "format": "{icon}",
        "format-icons": {
          "1": "1", "2": "2", "3": "3", "4": "4", "5": "5", "6": "6", "7": "7", "8": "8", "9": "9"
        }
      },
      "clock": {
        "format": "{:%H:%M}  ",
        "format-alt": "{:%A, %B %d, %Y (%R)}  ",
        "tooltip-format": "<tt><small>{calendar}</small></tt>",
        "calendar": {
          "mode"          : "year",
          "mode-mon-col"  : 3,
          "weeks-pos"     : "right",
          "on-scroll"     : 1,
          "on-click-right": "mode",
          "format": {
            "months":     "<span color='#ffead3'><b>{}</b></span>",
            "days":       "<span color='#ecc6d9'><b>{}</b></span>",
            "weeks":      "<span color='#99ffdd'><b>W{}</b></span>",
            "weekdays":   "<span color='#ffcc66'><b>{}</b></span>",
            "today":      "<span color='#ff6699'><b><u>{}</u></b></span>"
          }
        },
        "actions":  {
          "on-click-right": "mode",
          "on-click-forward": "tz_up",
          "on-click-backward": "tz_down",
          "on-scroll-up": "shift_up",
          "on-scroll-down": "shift_down"
        }
      },
      "cpu": {
        "format": "{usage}% ",
        "tooltip": false
      },
      "memory": {
        "format": "{}% "
      },
      "network": {
        "format-wifi": "{essid} ({signalStrength}%) ",
        "format-ethernet": "{ipaddr}/{cidr} ",
        "tooltip-format": "{ifname} via {gwaddr} ",
        "format-linked": "{ifname} (No IP) ",
        "format-disconnected": "Disconnected ⚠",
        "format-alt": "{ifname}: {ipaddr}/{cidr}"
      },
      "pulseaudio": {
        "format": "{volume}% {icon} {format_source}",
        "format-bluetooth": "{volume}% {icon} {format_source}",
        "format-bluetooth-muted": " {icon} {format_source}",
        "format-muted": " {format_source}",
        "format-source": "{volume}% ",
        "format-source-muted": "",
        "format-icons": {
            "headphone": "",
            "hands-free": "",
            "headset": "",
            "phone": "",
            "portable": "",
            "car": "",
            "default": ["", "", ""]
        },
        "on-click": "pavucontrol"
      }
    }
    ]
  '';

  xdg.configFile."waybar/style.css".text = ''
    * {
        border: none;
        border-radius: 0;
        font-family: Roboto, Helvetica, Arial, sans-serif;
        font-size: 13px;
        min-height: 0;
    }

    window#waybar {
        background-color: rgba(43, 48, 59, 0.5);
        border-bottom: 3px solid rgba(100, 114, 125, 0.5);
        color: #ffffff;
        transition-property: background-color;
        transition-duration: .5s;
    }

    window#waybar.hidden {
        opacity: 0.2;
    }

    #workspaces button {
        padding: 0 5px;
        background-color: transparent;
        color: #ffffff;
    }

    #workspaces button:hover {
        background: rgba(0, 0, 0, 0.2);
        box-shadow: inherit;
        border-bottom: 3px solid #ffffff;
    }

    #workspaces button.active {
        background-color: #64727D;
        border-bottom: 3px solid #ffffff;
    }

    #clock,
    #battery,
    #cpu,
    #memory,
    #disk,
    #temperature,
    #backlight,
    #network,
    #pulseaudio,
    #custom-media,
    #tray,
    #mode,
    #idle_inhibitor,
    #scratchpad,
    #mpd {
        padding: 0 10px;
        color: #ffffff;
    }

    #window {
        border-style: hidden;
    }

    #workspaces {
        margin: 0 4px;
    }
  '';

  # Mako (Notifications)
  services.mako = {
    enable = true;
    defaultTimeout = 5000;
    borderSize = 2;
    borderRadius = 5;
    backgroundColor = "#1e1e2e";
    borderColor = "#89b4fa";
    textColor = "#cdd6f4";
  };

  # Cliphist (Clipboard Manager)
  services.cliphist = {
    enable = true;
    allowImages = true;
    systemdTargets = [ "graphical-session.target" ];
  };

  # Swaylock (Screen Lock)
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      daemonize = true;
      ignore-empty-password = true;
      font-size = 20;
      indicator-idle-visible = false;
      indicator-radius = 100;
      show-failed-attempts = true;
    };
  };

  # Swayidle (Idle Management)
  services.swayidle = {
    enable = true;
    systemdTarget = "graphical-session.target";
    events = [
      { event = "before-sleep"; command = "${pkgs.swaylock-effects}/bin/swaylock -fF"; }
      { event = "lock"; command = "${pkgs.swaylock-effects}/bin/swaylock -fF"; }
    ];
    timeouts = [
      { timeout = 300; command = "${pkgs.swaylock-effects}/bin/swaylock -fF"; }
      { timeout = 600; command = "niri msg action power-off-monitors"; resumeCommand = "niri msg action power-on-monitors"; }
    ];
  };

  # Rofi (Application Launcher)
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    cycle = true;
    terminal = "${pkgs.foot}/bin/foot";
    # Add theme or config here if needed
  };

  # Helpers
  home.file.".config/niri/scripts/niri-color-picker".source = pkgs.writeShellScript "niri-color-picker" ''
    niri msg pick-color | awk '$1 == "Hex:" { printf "%s", $2 }' | wl-copy
  '';
}
