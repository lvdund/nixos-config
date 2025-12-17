{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/119e28cb-acad-4ef2-b723-0e521b9acc50";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/4F4B-A5D2";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  # Auto-mount sda1 (Data drive) to /mnt/mydata
  fileSystems."/mnt/mydata" = {
    device = "/dev/disk/by-uuid/5bee94e2-64a0-41ac-ab57-37d05615e939";
    fsType = "ext4";
    options = [ 
      "defaults"
      "nofail"      # Don't fail boot if drive is missing
    ];
  };

  swapDevices = [{device = "/dev/disk/by-uuid/7558c6fa-c16e-40b3-a286-cdb386548626";}];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
