{ config, pkgs, ... }: {
  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      experimental = true;
      default-address-pools = [
        {
          base = "172.30.0.0/16";
          size = 24;
        }
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    docker-compose
  ];

  users.users.vd.extraGroups = [ "docker" ];
}
