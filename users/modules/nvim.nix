{
  repoRoot ? "/etc/nixos/nixos-config",
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    neovim
    # formatters used by config/nvim/lua/core/format.lua ("gf")
    stylua # lua
    black # python
    alejandra # nix
    yamlfmt # yaml
    gofumpt # go
    gotools # provides goimports
  ];

  # Link your custom configs
  home.file = {
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${repoRoot}/config/nvim";
  };
}
