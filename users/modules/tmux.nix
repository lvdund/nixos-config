{
  config,
  pkgs,
  ...
}: {
  programs.tmux = { enable = true; };
  home.file = {
    ".tmux.conf".source = config.lib.file.mkOutOfStoreSymlink 
              "/etc/nixos/nixos-config/config/tmux.conf";
  };
}
