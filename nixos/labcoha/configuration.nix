{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../common.nix
    ./hardware-configuration.nix
    ../modules/gtp5g.nix
    ../modules/i3.nix
  ];

  networking.hostName = "labcoha";

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

  users.users.lab = {
    isNormalUser = true;
    description = "lab";
    shell = pkgs.fish;
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "audio"
      "docker"
    ];
  };

  security.sudo.wheelNeedsPassword = lib.mkForce true;
  security.sudo.extraRules = [
    {
      users = ["vd"];
      runAs = "ALL";
      commands = [
        {
          command = "ALL";
          options = ["SETENV" "NOPASSWD"];
        }
      ];
    }
  ];

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
