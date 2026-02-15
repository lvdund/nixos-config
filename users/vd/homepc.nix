{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    # inputs.niri-flake.homeModules.niri
    ./modules/obs.nix
    ./modules/brave.nix
    ./modules/fish.nix
    ./modules/yazi.nix
    ./modules/neovim.nix
    ./modules/tmux.nix
    ./modules/direnv.nix
    ./modules/niri-homepc.nix
  ];
  home.username = "vd";
  home.homeDirectory = "/home/vd";
  home.stateVersion = "25.11";

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

  # Packages for user
  home.packages = with pkgs; [
    wpsoffice
    protonup-qt
    vscode
    pciutils
    parted
    gdu
    gparted

    sshfs
    file-roller

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

    nodejs_20
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

  # Link your custom configs
  home.file = {
    ".config/yazi".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/config/yazi";
    ".config/kitty".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/config/kitty";
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/config/nvim";
    ".config/zathura".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/config/zathura";
  };

  programs = {
    home-manager.enable = true;
  };
}
