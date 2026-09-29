{pkgs, ...}: {
  # Install Micromamba
  # (Fish integration lives in config/fish-pc/config.fish — we can't use
  # programs.fish here because fish_pc.nix symlinks the whole .config/fish dir)
  home.packages = with pkgs; [
    micromamba
  ];
}
