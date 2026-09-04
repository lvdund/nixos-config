{
  repoRoot ? "/etc/nixos/nixos-config",
  config,
  ...
}: {
  # Link your custom configs
  home.file = {
    ".config/mako".source = config.lib.file.mkOutOfStoreSymlink "${repoRoot}/config/mako";
  };
}
