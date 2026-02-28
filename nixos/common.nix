{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./modules/network.nix
    ./modules/docker.nix
    ./modules/fish.nix
    ./modules/input.nix
    ./modules/fonts.nix
  ];

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

  # services.upower.enable = true;

  environment.systemPackages = with pkgs; [
    # Core utilities
    git
    gh
    fzf
    fd
    bat
    ripgrep
    lsd
    wget
    curl
    net-tools
    iptables
    linuxHeaders # Kernel headers for development
    gnumake
    gcc14
    kmod
    btop

    # Compression tools
    zip
    unzip
    rar
    unrar

    # Desktop environment
    libnotify
    feh
    maim
    kitty
    nautilus
    process-viewer
    zathura
    evince
    arandr

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
