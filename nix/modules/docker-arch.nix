{
  config,
  pkgs,
  ...
}: {
  # Docker configuration for Arch Linux with Nix
  # Note: Docker daemon must be installed and enabled on the Arch system
  # Run: sudo systemctl enable --now docker
  # Add user to docker group: sudo usermod -aG docker vd
  
  home.packages = with pkgs; [
    docker
    docker-compose
    docker-buildx
    lazydocker # TUI for docker management
  ];

  # Docker completion for fish shell
  programs.fish = {
    shellAliases = {
      d = "docker";
      dc = "docker-compose";
      dps = "docker ps";
      di = "docker images";
      dex = "docker exec -it";
      dlog = "docker logs -f";
      drm = "docker rm";
      drmi = "docker rmi";
      dprune = "docker system prune -af";
    };
  };
}
