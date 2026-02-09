{
  pkgs,
  ...
}: {
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.symbols-only
    corefonts
  ];
  fonts.fontconfig.defaultFonts = {
    monospace = ["FiraCode Nerd Font"];
  };
}
