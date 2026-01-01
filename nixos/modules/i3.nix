{ config, pkgs, ... }: {
  services.xserver = {
    windowManager.i3.enable = true;
  };
  services.displayManager.defaultSession = "none+i3";

  environment.systemPackages = with pkgs; [
    i3
    i3status
    i3lock
    dmenu
    rofi
  ];
}
