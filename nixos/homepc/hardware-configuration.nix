{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/119e28cb-acad-4ef2-b723-0e521b9acc50";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/4F4B-A5D2";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  # Auto-mount sda1 (Data drive) to /mnt/mydata (lazy/systemd automount)
  fileSystems."/mnt/mydata" = {
    device = "/dev/disk/by-uuid/5bee94e2-64a0-41ac-ab57-37d05615e939";
    fsType = "ext4";
    options = [
      "defaults"
      "nofail" # Don't fail boot if drive is missing
      "x-systemd.automount" # Mount on first access, not at boot
      "x-systemd.idle-timeout=600" # Unmount after 10 min idle
      "x-systemd.mount-timeout=10" # Give up mounting after 10 s (don't hang on dead disk)
      # NOTE: ext4 does NOT support uid/gid/fmask/dmask (FAT/exFAT only) and
      # refuses to mount with them; ownership is stored on the inodes and set by
      # the setup-data-permissions.service below (chown -R vd:users).
    ];
  };

  # Auto-mount nvme1n1p1 to /mnt/nvme1 (lazy/systemd automount)
  fileSystems."/mnt/nvme1" = {
    device = "/dev/disk/by-uuid/b94e3aa2-8dd0-4847-8e7d-602bb1dde7f6";
    fsType = "ext4";
    options = [
      "defaults"
      "nofail" # Don't fail boot if drive is missing
      "x-systemd.automount" # Mount on first access, not at boot
      "x-systemd.idle-timeout=3000" # Unmount after 50 min idle
      "x-systemd.mount-timeout=10" # Give up mounting after 10 s (don't hang on dead disk)
      # NOTE: ext4 does NOT support uid/gid/fmask/dmask (FAT/exFAT only) and
      # refuses to mount with them; set ownership on the inodes instead
      # (e.g. chown -R vd:users /mnt/nvme1).
    ];
  };

  swapDevices = [{device = "/dev/disk/by-uuid/7558c6fa-c16e-40b3-a286-cdb386548626";}];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
