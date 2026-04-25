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
    GOPATH = "${config.home.homeDirectory}/env/gopath_main";
    JAVA_HOME = "${pkgs.jdk21}/lib/openjdk";
  };
  home.sessionPath = [
    "${config.home.homeDirectory}/.npm-global/bin"
    "${config.home.homeDirectory}/env/gopath_main/bin"
    "${config.home.homeDirectory}/.local/bin"
    "${config.home.homeDirectory}/.cargo/bin"
  ];

  # Packages for user
  home.packages = with pkgs;
    [
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
      jdt-language-server

      nodejs
      python312
      jdk21
      maven
      spring-boot-cli
      rustup
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
    ]
    ++ [unstable.neovim];

  # directories exist
  home.activation.createDirs = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p ${config.home.homeDirectory}/env
    mkdir -p ${config.home.homeDirectory}/env/gopath_main/{bin,pkg,src}
  '';

  home.file = {
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos/nixos-config/config/nvim";
  };
}
