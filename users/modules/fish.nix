{
  repoRoot ? "/etc/nixos/nixos-config",
  config,
  ...
}: {
  # Link your custom configs
  home.file = {
    ".config/fish".source = config.lib.file.mkOutOfStoreSymlink "${repoRoot}/config/fish";
  };
}
