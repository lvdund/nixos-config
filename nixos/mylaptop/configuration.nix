{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../common.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "mylaptop";

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  boot.kernelPackages = pkgs.linuxPackages_6_1;

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    pulseaudio.enable = false;
  };
}

