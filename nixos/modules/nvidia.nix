{
  config,
  pkgs,
  lib,
  ...
}: {
  services.xserver.videoDrivers = ["nvidia"];

  # services.ollama = {
  #   enable = true;
  #   acceleration = "cuda";
  # };

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

  # Install CUDA toolkit for ollama - binaries from cache
  environment.systemPackages = with pkgs; [
    cudaPackages.cudatoolkit
    cudaPackages.cudnn
    cudaPackages.cuda_cudart
	ollama
  ];
  environment.sessionVariables = {
    CUDA_HOME = "${pkgs.cudaPackages.cudatoolkit}";
    LD_LIBRARY_PATH = lib.makeLibraryPath [
      "${pkgs.cudaPackages.cudatoolkit}"
      "${pkgs.cudaPackages.cudatoolkit}/lib64"
      pkgs.cudaPackages.cudnn
      pkgs.cudaPackages.cuda_cudart
      pkgs.stdenv.cc.cc.lib
    ];
    CUDA_MODULE_LOADING = "LAZY";
  };

  # CUDA binary cache - prevents local builds
  nix.settings = {
    substituters = [
      "https://cuda-maintainers.cachix.org"
    ];
    trusted-public-keys = [
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };
}
