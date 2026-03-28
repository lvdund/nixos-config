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
    ".config/yazi".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/nixos-config/config/yazi";
  };
}
