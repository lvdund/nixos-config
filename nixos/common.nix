{
  config,
  pkgs,
  ...
}: {
  networking = {
    networkmanager.enable = true;
    firewall.enable = false;
  };

  nixpkgs.config.allowUnfree = true;

  services = {
    openssh.enable = true;
    displayManager.defaultSession = "none+i3";
    xserver = {
      enable = true;
      displayManager = {
        lightdm.enable = true;
      };
      windowManager.i3.enable = true;
      xkb.layout = "us";
    };
    gvfs.enable = true;
    tumbler.enable = true;
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = false;
    };
    pulseaudio.enable = false;
  };

  security = {
    rtkit.enable = true;
    sudo.wheelNeedsPassword = false;
  };

  programs = {
    fish.enable = true;
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
    dconf.enable = true;
  };

  environment.systemPackages = with pkgs; [
    # Core utilities
    git
    neovim
    tmux
    fzf
    fd
    bat
    ripgrep
    xclip
    lsd
    wget
    curl
    net-tools
    docker-compose
    font-manager

    # Compression tools
    zip
    unzip
    rar
    unrar

    # Desktop environment
    i3
    i3status
    i3lock
    dmenu
    rofi
    dunst
    feh
    maim
    kitty
    fish
    onlyoffice-desktopeditors

    # Audio/Video
    pavucontrol
    pulseaudio
    vlc

    # System tools
    brightnessctl
    lxappearance
    appimage-run
  ];

  time.timeZone = "Asia/Ho_Chi_Minh";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "vi_VN";
      LC_IDENTIFICATION = "vi_VN";
      LC_MEASUREMENT = "vi_VN";
      LC_MONETARY = "vi_VN";
      LC_NAME = "vi_VN";
      LC_NUMERIC = "vi_VN";
      LC_PAPER = "vi_VN";
      LC_TELEPHONE = "vi_VN";
      LC_TIME = "vi_VN";
    };
    inputMethod = {
      type = "fcitx5";
      enable = true;
      fcitx5.addons = with pkgs; [
        fcitx5-gtk
        kdePackages.fcitx5-unikey
      ];
    };
  };

  virtualisation = {
    virtualbox = {
      host = {
        enable = true;
      };
    };
    docker = {
      enable = true;
      daemon.settings = {
        experimental = true;
        default-address-pools = [
          {
            base = "172.30.0.0/16";
            size = 24;
          }
        ];
      };
    };
  };

  users.users.vd = {
    isNormalUser = true;
    description = "vd";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "audio"
      "docker"
      "vboxusers"
      "user-with-access-to-virtualbox"
    ];
    shell = pkgs.fish;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.symbols-only
    corefonts
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];
  system.stateVersion = "25.11";
}
