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
      
      # Custom prompt with user@hostname, pwd (full path with ... when > 3 dirs), and git branch
      function fish_prompt
        set -l last_status $status
        
        # User@hostname
        set_color cyan
        echo -n "$USER@"(hostname)" "
        
        # Get current directory (full path, truncate with ... when > 3 dirs)
        set_color blue
        echo -n (prompt_pwd --full-length-dirs 3)
        
        # Git branch (if in a git repo)
        if git rev-parse --git-dir > /dev/null 2>&1
          set -l git_branch (git branch 2>/dev/null | sed -n '/\* /s///p')
          set_color yellow
          echo -n " ($git_branch)"
        end

		if set -q DIRENV_DIR
          set_color magenta
          echo -n " ❄️"
        end
        
        # Prompt symbol (color based on last command status)
        if test $last_status -eq 0
          set_color green
        else
          set_color red
        end
        
        set_color normal
        echo -n " > "
      end
    '';
  };
}
