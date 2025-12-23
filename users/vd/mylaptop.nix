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
    gnumake
    gcc15
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

  # i3 configuration
  xsession.windowManager.i3 = {
    enable = true;
    config = null; # use your custom config
  };

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
    ".tmux.conf".source = ../../config/tmux/tmux.conf;
    ".tmux".source = ../../config/tmux;
    ".config/i3".source = ../../config/i3-mylaptop;
    ".config/i3status".source = ../../config/i3status-mylatop;
    ".config/rofi".source = ../../config/rofi;
    ".config/dunst".source = ../../config/dunst;
    ".config/kitty".source = ../../config/kitty;
    ".config/nvim".source = ../../config/nvim;
    ".config/Thunar".source = ../../config/Thunar;
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
  };
}
