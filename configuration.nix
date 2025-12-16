{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  #boot.loader.grub = {
  #  enable = true;
  #  device = "/dev/sda";
  #  useOSProber = true;
  #};
  
  # kernel
  boot.kernelPackages = pkgs.linuxPackages_6_1;

  ################## nvidia ##################
  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "nvidia-drm.fbdev=1"
  ];
  # Load the nvidia driver for Xorg and Wayland
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    prime = {
      nvidiaBusId = "PCI:1:0:0";
    };
  };
  ################## nvidia ##################

  # Networking
  networking = {
    hostName = "homepc";
    networkmanager.enable = true;
    firewall.enable = false;
  };

  nixpkgs.config.allowUnfree = true;
  
  # Services
  services = {
    openssh.enable = true;
    xserver = {
      enable = true;
      displayManager = {
        lightdm.enable = true;
        defaultSession = "none+i3";
      };
      windowManager.i3.enable = true;
      xkb.layout = "us";
	  videoDrivers = [ "nvidia" ];
      # resolutions = [
      #   { x = 1920; y = 1080; }
      # ];
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
  };
  security.rtkit.enable = true;
  hardware.pulseaudio.enable = false;

  # Programs
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
      # ...
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
  };


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

  # User account
  users.users.vd = {
    isNormalUser = true;
    description = "vd";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" ];
	shell = pkgs.fish;
  };
  
  # Passwordless sudo (security risk - consider removing)
  security.sudo.wheelNeedsPassword = false;

  # System packages
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
    
    # Audio/Video
    pavucontrol
	pulseaudio
    vlc
    
    # System tools
    brightnessctl
    lxappearance
    appimage-run
  ];
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.symbols-only
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.11";
  systemd.services.setup-data-permissions = {
    description = "Set full permissions on /mnt/mydata";
    after = [ "mnt-mydata.mount" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p /mnt/mydata";
      ExecStart = [
        "${pkgs.coreutils}/bin/chown -R vd:users /mnt/mydata"
        "${pkgs.coreutils}/bin/chmod -R 755 /mnt/mydata"
      ];
    };
  };
}
