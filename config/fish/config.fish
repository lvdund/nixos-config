# Manually add paths to PATH (bypassing hm-session-vars.sh guard)
# This ensures PATH works in non-login SSH sessions
if not contains $HOME/.npm-global/bin $PATH
  fish_add_path $HOME/.npm-global/bin
end
if not contains $HOME/env/gopath_main/bin $PATH
  fish_add_path $HOME/env/gopath_main/bin
end
if not contains $HOME/.local/bin $PATH
  fish_add_path $HOME/.local/bin
end
if not contains $HOME/.cargo/bin $PATH
  fish_add_path $HOME/.cargo/bin
end

set fish_greeting # Disable greeting

# Aliases
alias v='nvim'
alias vi='nvim'
alias ls='lsd'
alias lsla='lsd -la'
alias grep='grep --color=auto'
alias gs='git status'
alias ga='git add'
alias gcm='git commit -m'
alias gph='git push'
alias gpl='git pull'
alias gco='git checkout'
alias cls="printf '\033[2J\033[3J\033[1;1H'"
alias ssh-kitty='kitty +kitten ssh'
alias ssh-vagrant-kitty='env TERM=xterm-256color vagrant ssh'
alias sudo-wayland='sudo -E WAYLAND_DISPLAY=$WAYLAND_DISPLAY XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR'

# --- Cached git branch for the prompt ---
# Spawning git costs ~25ms on macOS, so fish_prompt NEVER runs git.
# The cache refreshes after each real command (branch may have changed)
# and whenever $PWD changes; a bare Enter re-renders with zero spawns.
function __update_prompt_git_branch --description "Refresh cached git branch for the prompt"
    set -g __prompt_git_branch (command git branch --show-current 2>/dev/null)
    if test -z "$__prompt_git_branch"
        # detached HEAD (or not a repo): fall back to short SHA; empty outside repos
        set __prompt_git_branch (command git rev-parse --short HEAD 2>/dev/null)
    end
end

function __refresh_git_branch_postexec --on-event fish_postexec
    if set -q __prompt_git_skip_postexec # PWD hook already refreshed for this command
        set -e __prompt_git_skip_postexec
        return
    end
    __update_prompt_git_branch
end

function __refresh_git_branch_on_cd --on-variable PWD
    set -g __prompt_git_skip_postexec 1
    __update_prompt_git_branch
end

# Custom prompt with user@hostname, pwd (full path with ... when > 3 dirs), and git branch
function fish_prompt
  set -l last_status $status

  # User@hostname ($hostname is a fish special variable — no process spawn)
  set_color cyan
  echo -n "$USER@$hostname "

  # Get current directory (full path, truncate with ... when > 3 dirs)
  set_color blue
  echo -n (prompt_pwd --full-length-dirs 3)

  # Git branch (cached — refreshed by the hooks above, not here)
  if not set -q __prompt_git_branch
    __update_prompt_git_branch # first prompt of the session
  end
  if test -n "$__prompt_git_branch"
    set_color yellow
    echo -n " ($__prompt_git_branch)"
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

eval "$(/opt/homebrew/bin/brew shellenv fish)"
