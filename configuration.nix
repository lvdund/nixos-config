{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
    useOSProber = true;
  };

  # Networking
  networking = {
    hostName = "homepc";
    networkmanager.enable = true;
    # WARNING: Firewall disabled - only do this on trusted networks!
    firewall.enable = false;
  };
  
  # Services
  services = {
    openssh.enable = true;
    
    # X11 and display manager
    xserver = {
      enable = true;
      displayManager = {
        lightdm.enable = true;
        defaultSession = "none+i3";
      };
      windowManager.i3.enable = true;
      xkb.layout = "us";
      resolutions = [
        { x = 1920; y = 1080; }
      ];
    };
    
    # File manager support
    gvfs.enable = true;
    tumbler.enable = true;
    
    # Sound
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
  };

  # Programs
  programs = {
    i3lock.enable = true;
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
  };

  # Sound
  security.rtkit.enable = true;

  # Time zone and locale
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
  };

  # User account
  users.users.vd = {
    isNormalUser = true;
    description = "vd";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" ];
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
    
    # i3 and desktop
    i3
    i3status
    i3lock
    dmenu
    rofi
    dunst
    feh
    maim
    
    # Applications
    firefox
    kitty
    pavucontrol
    lxappearance
    
    # Shell
    fish
    
    # Python (system-wide for basic use)
    python312
  ];

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.11";
}