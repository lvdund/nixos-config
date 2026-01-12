{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./modules/i3.nix
    ./modules/docker.nix
    ./modules/virtualbox.nix
    ./modules/fish.nix
    ./modules/input.nix
    ./modules/fonts.nix
  ];
  networking = {
    networkmanager.enable = true;
    firewall.enable = false;
  };

  nixpkgs.config.allowUnfree = true;

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
    config.common.default = "*";
  };

  security = {
    rtkit.enable = true;
    sudo.wheelNeedsPassword = false;
  };

  environment.systemPackages = with pkgs; [
    # Core utilities
    git
    gh
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
    iptables
    linuxHeaders # Kernel headers for development
    gnumake
    gcc14
    nix-prefetch-github
    kmod
    trash-cli

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
  ];

  users.users.vd = {
    isNormalUser = true;
    description = "vd";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "audio"
    ];
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];
  system.stateVersion = "25.11";
}
