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

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      prime = {
        nvidiaBusId = "PCI:1:0:0";
      };
    };
    pulseaudio.enable = false;
  };

  systemd.services.setup-data-permissions = {
    description = "Set full permissions on /mnt/mydata";
    after = ["mnt-mydata.mount"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p /mnt/mydata";
      ExecStart = [
        "${pkgs.coreutils}/bin/chown -R vd:users /mnt/mydata"
        "${pkgs.coreutils}/bin/chmod -R 755 /mnt/mydata"
      ];
    };
  };
}
