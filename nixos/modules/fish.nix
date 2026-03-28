{ config, pkgs, ... }: {
  programs.fish.enable = true;

  users.users.vd.shell = pkgs.fish;

  environment.systemPackages = with pkgs; [
    fish
  ];
}
