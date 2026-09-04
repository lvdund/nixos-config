{
  config,
  pkgs,
  ...
}: {
  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true; # every host uses fish as login shell
      nix-direnv.enable = true;
    };
    bash.enable = true;
  };
}
