{ config, pkgs, ... }: {
  programs.fish = {
    enable = true;
    shellAliases = {
      v = "nvim";
      vi = "nvim";
      ls = "lsd";
      lsla = "lsd -la";
      grep = "grep --color=auto";
      gs = "git status";
      ga = "git add";
      gcm = "git commit -m";
      cls = "printf '\\033[2J\\033[3J\\033[1;1H'";
      ssh-kitty = "kitty +kitten ssh";
      ssh-vagrant-kitty = "env TERM=xterm-256color vagrant ssh";
    };
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
  };
}
