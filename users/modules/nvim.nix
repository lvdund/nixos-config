{
  repoRoot ? "/etc/nixos/nixos-config",
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    neovim
    stylua # lua
    black # python
    alejandra # nix
    yamlfmt # yaml
    gofumpt # go
    gotools # provides goimports
    shfmt
    jq
  ];

  # Link your custom configs
  home.file = {
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${repoRoot}/config/nvim";
  };
}
