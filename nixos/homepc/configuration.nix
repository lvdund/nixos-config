{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../common.nix
    ./hardware-configuration.nix
    ../modules/nvidia.nix
  ];

  networking.hostName = "homepc";

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
    kernel.sysctl = {
      "net.ipv4.conf.eth0.forwarding" = 1; # enable port forwarding
    };
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

  environment.systemPackages = with pkgs; [
    linuxPackages_6_1.kernel.dev
  ];

  environment.variables = {
    KDIR = "${pkgs.linuxPackages_6_1.kernel.dev}/lib/modules/${pkgs.linuxPackages_6_1.kernel.modDirVersion}/build";
  };
}
