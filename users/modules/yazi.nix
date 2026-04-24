{
  config,
  pkgs,
  ...
}: {
  programs.yazi = {
    enable = true;

    plugins = {
      yatline = pkgs.yaziPlugins.yatline;
      yatline-githead = pkgs.yaziPlugins.yatline-githead;
      yatline-catppuccin = pkgs.yaziPlugins.yatline-catppuccin;
    };

    initLua = ''
      require("yatline"):setup()

      local catppuccin_theme = require("yatline-catppuccin"):setup("mocha") -- or "latte" | "frappe" | "macchiato"
      require("yatline"):setup({
        theme = catppuccin_theme,
      })

      local git_theme = {
        branch_color = "blue",
        remote_branch_color = "bright magenta",
        tag_color = "magenta",
        commit_color = "bright magenta",
        behind_remote_color = "bright magenta",
        ahead_remote_color = "bright magenta",
        stashes_color = "bright magenta",
        state_color = "red",
        staged_color = "bright yellow",
        unstaged_color = "bright yellow",
        untracked_color = "blue",
      }

      require("yatline-githead"):setup({
        theme = git_theme,
      })
    '';

    settings = {
      mgr = {show_hidden = true;};

      preview = {
        max_width = 1000;
        max_height = 1000;
      };

      opener = {
        edit = [
          {
            run = ''nvim "$@"'';
            block = true;
            orphan = true;
          }
        ];
        feh = [
          {
            run = ''feh "$1"'';
            orphan = true;
          }
        ];
        vlc = [
          {
            run = ''vlc "$@"'';
            orphan = true;
          }
        ];
      };

      open = {
        rules = [
          {
            mime = "image/*";
            use = "feh";
          }
          {
            mime = "video/*";
            use = "vlc";
          }
          {
            mime = "audio/*";
            use = "vlc";
          }
          {
            mime = "*";
            use = "edit";
          }
        ];
      };
    };
  };
}
