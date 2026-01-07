{
  config,
  pkgs,
  ...
}: {
  # Fish shell configuration
  programs.fish = {
    enable = true;
    
    shellInit = ''
      # Disable greeting
      set -g fish_greeting
      
      # Vi mode
      fish_vi_key_bindings
    '';
    
    shellAliases = {
      # Basic aliases
      ls = "lsd";
      ll = "lsd -la";
      lt = "lsd --tree";
      cat = "bat";
      
      # Git aliases
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git log --oneline --graph";
      gd = "git diff";
      
      # Navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      
      # Nix aliases
      hm = "home-manager";
      hmswitch = "home-manager switch --flake ~/.config/nixos-config/nix#vd";
      hmedit = "nvim ~/.config/nixos-config/nix/configuration.nix";
    };
    
    functions = {
      mkcd = "mkdir -p $argv[1]; and cd $argv[1]";
      backup = "cp $argv[1] $argv[1].bak";
    };
  };
}
