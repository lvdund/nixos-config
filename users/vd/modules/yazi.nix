{
  config,
  pkgs,
  ...
}: {
  programs = {
    yazi.enable = true;
    fish.shellAliases = { yy = "yazi"; };
  };
}
