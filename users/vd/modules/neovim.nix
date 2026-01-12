{
  config,
  pkgs,
  ...
}: {
  programs.neovim = {
    enable = true;
    extraLuaPackages = ps: [ps.magick];
    extraPackages = [
      pkgs.ueberzugpp
      pkgs.imagemagick
    ];
  };
}
