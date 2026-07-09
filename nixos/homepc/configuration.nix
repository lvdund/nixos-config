{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../common.nix
    ./hardware-configuration.nix
    ../modules/nvidia.nix
    ../modules/gtp5g.nix
    ../modules/virtualbox.nix
    ../modules/i3.nix
    ../modules/network_homepc.nix
  ];

  networking.hostName = "homepc";

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

  boot = {
    loader = {
      # for systemd
      systemd-boot.enable = true;
      timeout = 90;
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
    # Ensure the (lazy x-systemd.automount) filesystem is actually mounted before
    # chown/chmod run, otherwise chown hits an unmounted autofs node and fails.
    unitConfig.RequiresMountsFor = "/mnt/mydata";
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
