{ config, pkgs, ... }:

{
  # Build and install gtp5g kernel module
  boot.extraModulePackages = [
    (pkgs.callPackage ../../packages/gtp5g {
      kernel = config.boot.kernelPackages.kernel;
    })
  ];
  
  # Auto-load the modules at boot
  boot.kernelModules = [ "udp_tunnel" "gtp5g" ];
}
