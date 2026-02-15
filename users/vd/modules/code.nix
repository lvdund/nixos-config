{
  config,
  pkgs,
  lib,
  ...
}: {
  # Environment variables
  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    GOPATH = "${config.home.homeDirectory}/env/gopath_main";
    GOROOT = "${pkgs.go}/share/go";
  };
  home.sessionPath = [
    "${config.home.homeDirectory}/.npm-global/bin"
    "${config.home.homeDirectory}/env/gopath_main/bin"
    "${config.home.homeDirectory}/.local/bin"
  ];

  programs.neovim = {
    enable = true;
    extraLuaPackages = ps: [ps.magick];
    extraPackages = [
      pkgs.ueberzugpp
      pkgs.imagemagick
    ];
  };

  # Packages for user
  home.packages = with pkgs; [
    nixd
    delta
    basedpyright
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

    nodejs
    rustup
    uv
    clang-tools
    cmake
    lua-language-server
    stylua
    alejandra
    black
    dockerfmt
    yamlfmt
  ];

  # directories exist
  home.activation.createDirs = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p ${config.home.homeDirectory}/env
    mkdir -p ${config.home.homeDirectory}/env/gopath_main/{bin,pkg,src}
  '';

  home.file = {
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/config/nvim";
  };
}
