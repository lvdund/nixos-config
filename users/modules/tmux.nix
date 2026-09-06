{
  repoRoot ? "/etc/nixos/nixos-config",
  config,
  pkgs,
  ...
}: {
  home.file = {
    ".config/tmux".source = config.lib.file.mkOutOfStoreSymlink
              "${repoRoot}/config/tmux";
  };
}
