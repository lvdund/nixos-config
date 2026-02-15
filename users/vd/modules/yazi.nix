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
    ".config/yazi".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/config/yazi";
  };
}
