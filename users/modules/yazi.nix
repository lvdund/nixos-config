{
  config,
  pkgs,
  ...
}: {
  programs = {
    yazi.enable = true;
    fish.shellAliases = { yy = "yazi"; };
  };
  home.file = {
    ".config/yazi".source = config.lib.file.mkOutOfStoreSymlink "/tmp/nixos-config/config/yazi";
  };
}
