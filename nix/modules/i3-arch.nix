{
  config,
  pkgs,
  ...
}: {
  # i3 window manager configuration for Arch Linux
  # This assumes X11 is already set up on the Arch system
  
  home.packages = with pkgs; [
    i3
    i3status
    i3lock
    dmenu
    rofi
    acpi # For battery information
    
    # Additional i3 utilities
    picom # Compositor for transparency/effects
    arandr # Display manager
    xautolock # Auto-lock screen
    scrot # Screenshot tool (alternative to maim)
    
    # Thunar file manager and plugins
    xfce.thunar
    xfce.thunar-archive-plugin
    xfce.thunar-media-tags-plugin
    xfce.thunar-volman
  ];

  # XDG portal support (for file pickers, etc.)
  xdg = {
    enable = true;
    mime.enable = true;
    mimeApps.enable = true;
  };

  # i3 configuration
  xsession = {
    enable = true;
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3;
      
      config = {
        modifier = "Mod4"; # Use Super/Windows key
        terminal = "kitty";
        menu = "rofi -show drun";
        
        keybindings = let
          modifier = "Mod4";
        in {
          "${modifier}+Return" = "exec kitty";
          "${modifier}+Shift+q" = "kill";
          "${modifier}+d" = "exec rofi -show drun";
          
          # Focus
          "${modifier}+h" = "focus left";
          "${modifier}+j" = "focus down";
          "${modifier}+k" = "focus up";
          "${modifier}+l" = "focus right";
          
          # Move
          "${modifier}+Shift+h" = "move left";
          "${modifier}+Shift+j" = "move down";
          "${modifier}+Shift+k" = "move up";
          "${modifier}+Shift+l" = "move right";
          
          # Split
          "${modifier}+v" = "split v";
          "${modifier}+b" = "split h";
          
          # Fullscreen
          "${modifier}+f" = "fullscreen toggle";
          
          # Layout
          "${modifier}+s" = "layout stacking";
          "${modifier}+w" = "layout tabbed";
          "${modifier}+e" = "layout toggle split";
          
          # Floating
          "${modifier}+Shift+space" = "floating toggle";
          "${modifier}+space" = "focus mode_toggle";
          
          # Workspaces
          "${modifier}+1" = "workspace number 1";
          "${modifier}+2" = "workspace number 2";
          "${modifier}+3" = "workspace number 3";
          "${modifier}+4" = "workspace number 4";
          "${modifier}+5" = "workspace number 5";
          "${modifier}+6" = "workspace number 6";
          "${modifier}+7" = "workspace number 7";
          "${modifier}+8" = "workspace number 8";
          "${modifier}+9" = "workspace number 9";
          "${modifier}+0" = "workspace number 10";
          
          # Move to workspace
          "${modifier}+Shift+1" = "move container to workspace number 1";
          "${modifier}+Shift+2" = "move container to workspace number 2";
          "${modifier}+Shift+3" = "move container to workspace number 3";
          "${modifier}+Shift+4" = "move container to workspace number 4";
          "${modifier}+Shift+5" = "move container to workspace number 5";
          "${modifier}+Shift+6" = "move container to workspace number 6";
          "${modifier}+Shift+7" = "move container to workspace number 7";
          "${modifier}+Shift+8" = "move container to workspace number 8";
          "${modifier}+Shift+9" = "move container to workspace number 9";
          "${modifier}+Shift+0" = "move container to workspace number 10";
          
          # Reload/Restart
          "${modifier}+Shift+c" = "reload";
          "${modifier}+Shift+r" = "restart";
          "${modifier}+Shift+e" = "exec i3-msg exit";
        };
        
        bars = [{
          position = "bottom";
          statusCommand = "${pkgs.i3status}/bin/i3status";
          colors = {
            background = "#1e1e1e";
            statusline = "#ffffff";
            separator = "#666666";
          };
        }];
      };
    };
  };

  # Services for i3
  services = {
    dunst = {
      enable = true;
      settings = {
        global = {
          monitor = 0;
          follow = "mouse";
          geometry = "300x60-20+48";
          indicate_hidden = true;
          shrink = false;
          transparency = 10;
          notification_height = 0;
          separator_height = 2;
          padding = 8;
          horizontal_padding = 8;
          frame_width = 2;
          frame_color = "#89b4fa";
          separator_color = "frame";
          sort = true;
          idle_threshold = 120;
          font = "Monospace 10";
          line_height = 0;
          markup = "full";
          format = "<b>%s</b>\\n%b";
          alignment = "left";
          show_age_threshold = 60;
          word_wrap = true;
          ellipsize = "middle";
          ignore_newline = false;
          stack_duplicates = true;
          hide_duplicate_count = false;
          show_indicators = true;
        };
      };
    };
    
    picom = {
      enable = true;
      fade = true;
      fadeDelta = 5;
      shadow = true;
      shadowOpacity = 0.75;
    };
  };
}
