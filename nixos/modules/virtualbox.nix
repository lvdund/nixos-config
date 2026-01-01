{ config, pkgs, ... }: {
  virtualisation.virtualbox.host.enable = true;

  users.users.vd.extraGroups = [
    "vboxusers"
    "user-with-access-to-virtualbox"
  ];
}
