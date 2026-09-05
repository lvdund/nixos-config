{
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    # Headless-only shared modules (common.nix is NOT imported because it
    # pulls in GUI bits: xdg portal, fonts, input, kitty/thunar, dconf)
    ../modules/docker.nix
    ../modules/code.nix
    ../modules/fish.nix
    ../modules/sysctl.nix
    ../modules/tmpdir.nix
  ];

  networking.hostName = "myserver";

  users.users.vd = {
    isNormalUser = true;
    description = "vd";
    extraGroups = [
      "wheel"
      "docker"
    ];
  };

  # Passworded sudo for wheel (the NixOS default — kept explicit because
  # this box is reachable over SSH; no NOPASSWD/SETENV rules anywhere).
  security.sudo.wheelNeedsPassword = true;

  boot = {
    loader = {
      systemd-boot.enable = true;
      timeout = 5;
      efi.canTouchEfiVariables = true;
    };
  };

  # --- Server networking: SSH in, firewall on ---
  services.openssh = {
    enable = true;
    # Key-only login from day one (public keys are declared on
    # users.users.vd.openssh.authorizedKeys.keys above).
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    openFirewall = true;
  };

  networking = {
    # NetworkManager provides nmcli/nmtui for managing connections
    # over SSH/console (headless-friendly; nmtui is a TUI wizard).
    networkmanager.enable = true;
    firewall.enable = true;
  };

  # Headless box: only FiraCode Nerd Font, not the full fonts.nix set
  # (noto/cjk/corefonts are desktop-oriented).
  fonts.packages = with pkgs; [ nerd-fonts.fira-code ];

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Headless core utilities (subset of common.nix, minus desktop tools)
  environment.systemPackages = with pkgs; [
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
    net-tools
    ffmpeg

    # tools
    tcpdump
    iproute2
    iputils
    gawk
  ];

  # Fresh install from the 26.05 flake — pin at initial install,
  # never bump afterwards.
  system.stateVersion = "26.05";
}
