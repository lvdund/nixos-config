{ config, pkgs, ... }:
{
  home.username = "vd";
  home.homeDirectory = "/home/vd";
  home.stateVersion = "25.11";

  # Environment variables
  home.sessionVariables.MOZ_ENABLE_WAYLAND = "0";

  # Packages for user
  home.packages = with pkgs; [
    peazip
  ];

  # i3 configuration
  xsession.windowManager.i3 = {
    enable = true;
    config = null; # We'll use your custom config
  };

  # Link your custom configs
  home.file = {
    ".config/i3".source = ./config/i3;
    ".config/i3status".source = ./config/i3status;
    ".config/rofi".source = ./config/rofi;
    ".config/dunst".source = ./config/dunst;
    ".config/kitty".source = ./config/kitty;
    ".config/nvim".source = ./config/nvim;
    ".config/Thunar".source = ./config/Thunar;
  };

  programs = {
	home-manager.enable = true;
    fish.enable = true;
	chromium = {
	  enable = true;
	  package = pkgs.brave;
	  commandLineArgs = [
	    "--disable-features=WebRtcAllowInputVolumeAdjustment"
	  ];
	};
	neovim = {
      viAlias = true;
      vimAlias = true;
	  plugins = [
		pkgs.vimPlugins.nvim-treesitter
        pkgs.lua-language-server
        pkgs.nil
        pkgs.gopls
        pkgs.gofumpt
        pkgs.stylua
        pkgs.basedpyright
        pkgs.pyright
		pkgs.docker-compose-language-service
		pkgs.rust-analyzer
	  ];
	};
  };
}
