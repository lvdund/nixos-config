{
  config,
  pkgs,
  lib,
  ...
}: {
  home.username = "vd";
  home.homeDirectory = "/home/vd";
  home.stateVersion = "25.11";

  # Environment variables
  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "0";
    GOPATH = "${config.home.homeDirectory}/env/gopath_1_24";
    GOROOT = "${pkgs.go_1_24}/share/go";
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\\\${HOME}/.steam/root/compatibilitytools.d";
  };
  home.sessionPath = [
    "${config.home.homeDirectory}/.npm-global/bin"
    "${config.home.homeDirectory}/env/gopath_1_24/bin"
    "${config.home.homeDirectory}/.local/bin"
  ];

  # Packages for user
  home.packages = with pkgs; [
    wpsoffice
    protonup-qt
    vscode
    peazip
    pciutils
    nixd
    go_1_24
    nodejs_20
    rustup
    uv
    clang-tools
    cmake
    lua-language-server
    stylua
    alejandra
    black
    dockerfmt
    yamlfmt
  ];

  # directories exist
  home.activation.createDirs = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p ${config.home.homeDirectory}/env
    mkdir -p ${config.home.homeDirectory}/env/gopath_1_24/{bin,pkg,src}
  '';

  # i3 configuration managed by system and dotfiles
  # xsession.windowManager.i3 = {
  #   enable = true;
  #   config = null; # use your custom config
  # };

  # theme
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };
  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark"; # Or "Papirus", "Papirus-Light"
      package = pkgs.papirus-icon-theme;
    };
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
  };

  # Link your custom configs
  home.file = {
    ".tmux.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/config/tmux/tmux.conf";
    ".tmux".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/config/tmux";
    ".config/i3".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/config/i3-homepc";
    ".config/i3status".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/config/i3status-homepc";
    ".config/rofi".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/config/rofi";
    ".config/dunst".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/config/dunst";
    ".config/kitty".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/config/kitty";
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/config/nvim";
    ".config/Thunar".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/config/Thunar";
  };

  programs = {
    home-manager.enable = true;
    fish = {
      enable = true;
      shellAliases = {
        v = "nvim";
        vi = "nvim";
        ls = "lsd";
        lsla = "lsd -la";
        grep = "grep --color=auto";
        gs = "git status";
        ga = "git add";
        gcm = "git commit -m";
        cls = "printf '\\033[2J\\033[3J\\033[1;1H'";
        ssh-kitty = "kitty +kitten ssh";
        ssh-vagrant-kitty = "env TERM=xterm-256color vagrant ssh";
      };
      interactiveShellInit = ''
        set fish_greeting # Disable greeting
      '';
    };
    chromium = {
      enable = true;
      package = pkgs.brave;
      extensions = [
        {id = "nngceckbapebfimnlniiiahkandclblb";} # bitwarden password mana
        {id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";} # Dark Reader
      ];
      # commandLineArgs = [
      #   "--disable-features=WebRtcAllowInputVolumeAdjustment"
      # ];
    };
    obs-studio = {
      enable = true;
      package = (
        pkgs.obs-studio.override {
          cudaSupport = true;
        }
      );
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
        obs-gstreamer
        obs-vkcapture
      ];
    };
  };
}
