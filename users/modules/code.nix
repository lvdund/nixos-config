{
  config,
  pkgs,
  lib,
  unstable,
  ...
}: {
  # Environment variables
  home.sessionVariables = {
    # MOZ_ENABLE_WAYLAND = "1";
    GOPATH = "$HOME/env/gopath_main";
  };
  home.sessionPath = [
    "$HOME/.npm-global/bin"
    "$HOME/env/gopath_main/bin"
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
  ];

  # Packages for user
  home.packages = with pkgs; [
    nixd
    delta
    pyright
    go
    lazygit
    lazydocker
    delve
    gofumpt
    gomodifytags
    gotools
    gopls
    shfmt
    impl
    golangci-lint
    jq

    nodejs
    rustup
    uv
    clang-tools
    cmake
    lua-language-server
    bash-language-server
    docker-language-server
    stylua
    alejandra
    black
    dockerfmt
    yamlfmt

    obsidian
  ] ++ [unstable.neovim];

  # directories exist
  home.activation.createDirs = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p ${config.home.homeDirectory}/env
    mkdir -p ${config.home.homeDirectory}/env/gopath_main/{bin,pkg,src}
  '';

  home.file = {
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/nixos-config/config/nvim";
  };
}
