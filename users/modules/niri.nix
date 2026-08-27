{
  config,
  ...
}: {
  # Link your custom configs
  home.file = {
    ".config/mako".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/nixos-config/config/mako";
  };
}
