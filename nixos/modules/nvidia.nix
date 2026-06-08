{ config, pkgs, lib, ... }: {

  services.xserver.videoDrivers = ["nvidia"];

  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "nvidia-drm.fbdev=1"
  ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # 2. Use the native systemd service with pre-wrapped CUDA package
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda; 
  };

  # Force monitor to 120Hz on X11 startup
  services.xserver.displayManager.sessionCommands = ''
    ${pkgs.xrandr}/bin/xrandr --output DP-0 --mode 2560x1440 --rate 120
  '';

  # 3. Updated Official CUDA binary cache (Prevents local builds)
  nix.settings = {
    substituters = [
      "https://cache.nixos-cuda.org"
    ];
    trusted-public-keys = [
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
    ];
  };
}
