{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    terminal = "tmux-256color";
    prefix = "C-q";
    mouse = true;
    plugins = with pkgs; [
      tmuxPlugins.vim-tmux-navigator
      tmuxPlugins.catppuccin
	  tmuxPlugins.resurrect
	  tmuxPlugins.continuum
    ];
    extraConfig = ''
      set -g @catppuccin_flavor "mocha"
      set -g @catppuccin_window_status_style "rounded"

	  set -g @continuum-restore 'on'
	  set -g status-right 'Continuum status: #{continuum_status}'

	  set -g @resurrect-capture-pane-contents 'on'
      resurrect_dir="$HOME/.tmux/resurrect"

      set -g allow-passthrough on
      set -ag terminal-overrides ",$TERM:RGB"
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      set -g base-index 1 # Start windows numbering at 1 instead of 0
      setw -g pane-base-index 1 # start pane numbering at 1

      # set vi-mode
      set-window-option -g mode-keys vi
      # keybindings
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

      # vi->search mode
      bind / copy-mode \; send-keys /

      # create panel
      bind '"' split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
    '';
  };
}
