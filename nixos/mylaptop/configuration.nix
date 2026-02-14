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

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 90;
  boot.kernel.sysctl = {
    "net.ipv4.conf.eth0.forwarding" = 1; # enable port forwarding
  };
  boot.kernelPackages = pkgs.linuxPackages_6_1;

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
