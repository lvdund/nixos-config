{
  repoRoot ? "/Users/lvdund/nixos-config",
  config,
  pkgs,
  ...
}: {
  imports = [
    # Cross-platform user modules (no Linux-only bits inside)
    ../modules/nvim.nix
    ../modules/direnv.nix
    ../modules/browser.nix
    ../modules/git.nix
    ../modules/fish.nix
  ];

  home.username = "lvdund";
  home.homeDirectory = "/Users/lvdund";
  # Pin at first install, never bump afterwards
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    kitty
    fzf
    ripgrep
  ];

  # Link your custom configs — repoRoot is passed by the flake
  # (home-manager.extraSpecialArgs); adjust it there if the repo moves
  home.file = {
    ".config/kitty".source = config.lib.file.mkOutOfStoreSymlink "${repoRoot}/config/kitty";
  };

  # VS Code — HM writes settings/keybindings/extensions to
  # ~/Library/Application Support/Code/User on darwin automatically
  # (package defaults to pkgs.vscode, which ships native darwin-arm64 binaries;
  # vscode.fhs from the Linux hosts is Linux-only)
  programs.vscode.enable = true;

  programs = {
    home-manager.enable = true;
  };
}
