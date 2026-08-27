{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    neovim
  ];

  # Link your custom configs
  home.file = {
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/nixos-config/config/nvim";
  };
}
