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
  system.primaryUser = "lvdund";

  # Explicit hostname (don't rely on the macOS default, which has spaces/uppercase)
  networking.hostName = "macvd";
  networking.computerName = "macvd";
  networking.localHostName = "macvd";

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # fish integration for the Nix environment (writes /etc/fish/config.fish)
  programs.fish.enable = true;

  # nix-darwin manages /etc/shells ONLY via this option (programs.fish.enable
  # does NOT register it, unlike NixOS). chsh validates against /etc/shells.
  environment.shells = [ pkgs.fish ];

  # NOTE: on darwin this does NOT change the login shell for an admin user —
  # nix-darwin only runs `dscl ... UserShell` for users in users.knownUsers,
  # which the primary user must not be in. Enforced declaratively below.
  users.users.lvdund = {
    name = "lvdund";
    home = "/Users/lvdund";
    shell = pkgs.fish;
  };

  # Set the login shell on every rebuild (replaces the manual `chsh` step).
  # Runs as root during activation; `dscl . -create` is idempotent
  # (create-or-overwrite) — the same call nix-darwin uses internally.
  # In 26.05 only the named scripts run, so use postActivation, not a custom name.
  system.activationScripts.postActivation.text = ''
    echo "setting lvdund login shell to fish..." >&2
    dscl . -create /Users/lvdund UserShell /run/current-system/sw/bin/fish
  '';

  # Dev toolchain — mirrors nixos/modules/code.nix;
  # git + VS Code are managed by Home Manager in users/lvdund/macvd.nix
  # (git via users/modules/git.nix; vscode.fhs from Linux is Linux-only)
  environment.systemPackages = with pkgs; [
    fzf
    nodejs
    go
    clang-tools # clangd
    gopls
    lua-language-server
    nixd
    pyright
    rust-analyzer

    lsd
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
