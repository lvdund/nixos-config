{
  config,
  pkgs,
  ...
}: {
  # REQUIRED on darwin: platform is set here, not in darwinSystem
  nixpkgs.hostPlatform = "aarch64-darwin"; # "x86_64-darwin" on Intel Macs

  # Pin at initial install and never bump afterwards; read `darwin-rebuild
  # changelog` before changing. 7 is the correct initial value for a fresh
  # install from nix-darwin-26.05 (its system.maxStateVersion).
  system.stateVersion = 7;

  # REQUIRED by modern nix-darwin: options that used to apply to the user running
  # darwin-rebuild (system.defaults.*, security.pam.services.sudo_local.*, homebrew.*)
  # now need an explicit primary user.
  system.primaryUser = "vd";

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Make fish a proper login shell (registers it in /etc/shells)
  programs.fish.enable = true;

  users.users.vd = {
    name = "vd";
    home = "/Users/vd";
    shell = pkgs.fish;
  };

  # Dev toolchain — mirrors nixos/modules/code.nix;
  # git + VS Code are managed by Home Manager in users/vd/macbook.nix
  # (git via users/modules/git.nix; vscode.fhs from Linux is Linux-only)
  environment.systemPackages = with pkgs; [
    vim
    fzf
    nodejs
    go
    clang-tools # clangd
    gopls
    lua-language-server
    nixd
    pyright
    rust-analyzer
  ];

  # Per-user GOPATH so every account gets its own under $HOME.
  environment.shellInit = ''
    export GOPATH="$HOME/env/gopath_main"
  '';

  # Fonts for kitty/nvim (same set as nixos/modules/fonts.nix)
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.symbols-only
  ];

  # Touch ID / Apple Watch for sudo
  # (the old security.pam.enableSudoTouchIdAuth option was removed)
  security.pam.services.sudo_local.touchIdAuth = true;
  security.pam.services.sudo_local.watchIdAuth = true;

  ### Optional niceties — uncomment as desired ###

  # Homebrew: must be installed first at /opt/homebrew; this module only drives it
  # homebrew = {
  #   enable = true;
  #   casks = ["raycast"];
  #   # masApps = { "Xcode" = 497799835; };
  # };

  # Keyboard remaps (e.g. Caps Lock -> Control)
  # system.keyboard = {
  #   enableKeyMapping = true;
  #   remapCapsLockToControl = true;
  # };

  # Weekly garbage collection (launchd)
  # nix.gc = {
  #   automatic = true;
  #   options = "--delete-older-than 30d";
  # };
  # nix.optimise.automatic = true;

  # Dock / Finder tweaks
  system.defaults = {
    dock.autohide = true;
    finder.AppleShowAllExtensions = true;
    NSGlobalDomain.KeyRepeat = 2;
  };
}
