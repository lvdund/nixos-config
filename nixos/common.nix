{
  pkgs,
  ...
}: {
  imports = [
    ./modules/docker.nix
    ./modules/code.nix
    ./modules/fish.nix
    ./modules/input.nix
    ./modules/fonts.nix
    ./modules/sysctl.nix
    ./modules/tmpdir.nix
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

  programs.dconf.enable = true;

  environment.systemPackages = with pkgs; [
    # Core utilities
    wget
    curl
    btop
    zip
    unzip
    gnumake
    gcc14
    kmod
    linuxHeaders
    iptables
    ffmpeg
    net-tools

    # Terminal / desktop
    kitty
    thunar

    # tools
    wireshark
    tcpdump
    iproute2
    iputils
    gawk
  ];

  environment.sessionVariables.GTK_THEME = "Adwaita:dark";

  nix.settings.experimental-features = ["nix-command" "flakes"];
  system.stateVersion = "25.11";
}
