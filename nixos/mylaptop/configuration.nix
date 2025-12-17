{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../common.nix
    ./hardware-configuration.nix
  ];

  boot = {
    loader = {
      # for systemd
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      # for grub
      # grub = {
      #   enable = true;
      #   device = "/dev/sda";
      #   useOSProber = true;
      # };
    };
    kernelPackages = pkgs.linuxPackages_6_1;
    kernelParams = ["nvidia-drm.modeset=1" "nvidia-drm.fbdev=1"];
    kernel.sysctl = {
      "net.ipv4.conf.eth0.forwarding" = 1; # enable port forwarding
    };
  };

  hardware.pulseaudio.enable = false;
}
