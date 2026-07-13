{
  config,
  pkgs,
  ...
}: {
  home.file = {
    ".config/tmux".source = config.lib.file.mkOutOfStoreSymlink
              "/etc/nixos/nixos-config/config/tmux";
  };
}
