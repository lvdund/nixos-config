{
  config,
  pkgs,
  ...
}: {
  # This is a Nix Home Manager configuration for Arch Linux
  # Similar to homepc setup but without NVIDIA, VirtualBox, Vagrant
  # Only includes i3 and essential tools
  
  imports = [
    ./modules/i3-arch.nix
    ./modules/docker-arch.nix
    ./modules/fish.nix
    ./modules/fonts.nix
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Home Manager configuration for vd user
  home = {
    username = "vd";
    homeDirectory = "/home/vd";
    stateVersion = "25.11";
    
    packages = with pkgs; [
      # Core utilities
      git
      gh
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
      font-manager

      # Development tools
      gnumake
      gcc14
      nix-prefetch-github

      # Compression tools
      zip
      unzip
      rar
      unrar

      # Desktop environment
      dunst
      libnotify
      feh
      maim
      kitty
      nautilus
      process-viewer

      # Audio/Video
      pavucontrol
      pulseaudio
      vlc

      # System tools
      brightnessctl
      lxappearance
      appimage-run
      
      # i3 components
      i3
      i3status
      i3lock
      dmenu
      rofi
      acpi
    ];

    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  # Git configuration
  programs.git = {
    enable = true;
    userName = "vd";
    userEmail = "vd@archlinux";
  };

  # Enable Home Manager
  programs.home-manager.enable = true;
}
