{
  config,
  ...
}: {
  # Link your custom configs
  home.file = {
    ".config/fish".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/nixos-config/config/fish";
  };
}
