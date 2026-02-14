{
  config,
  pkgs,
  ...
}: {
  imports = [
    # ./modules/i3.nix
    ./modules/niri.nix
    ./modules/docker.nix
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
