{ config, pkgs, ... }: {
  virtualisation.virtualbox.host.enable = true;
  environment.systemPackages = with pkgs; [
    vagrant
  ];

  users.users.vd.extraGroups = [
    "vboxusers"
    "user-with-access-to-virtualbox"
  ];
}
