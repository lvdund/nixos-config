#!/usr/bin/env bash
# arch_dotfiles.sh — replace niri/waybar/fish/kitty/nvim dotfiles with the
# configs from this repo (config/ folder), managed by GNU stow.
#
# Usage (as your user, after arch_install.sh):
#   ./arch_dotfiles.sh [repo-dir]        # default: ~/nixos-config
#
# What it does:
#   1. install GNU stow if missing
#   2. remove old ~/.config/{niri,waybar,fish,kitty,nvim}
#   3. stow packages from <repo>/dotfiles into $HOME:
#        niri   -> config/niri-laptop
#        waybar -> config/waybar-laptop
#        fish   -> config/fish-sway
#        kitty  -> config/kitty
#        nvim   -> config/nvim

set -euo pipefail

REPO_DIR="${1:-$HOME/nixos-config}"
STOW_DIR="$REPO_DIR/dotfiles"
APPS=(niri waybar fish kitty nvim)

log() { printf '\033[1;32m==>\033[0m %s\n' "$*"; }
die() { printf '\033[1;31mERROR:\033[0m %s\n' "$*" >&2; exit 1; }

# ---------------------------------------------------------------- sanity ---
[[ $EUID -ne 0 ]]            || die "run as your user, not root"
[[ -d $STOW_DIR ]]           || die "stow dir not found: $STOW_DIR (pass repo dir as arg 1)"

# ------------------------------------------------ 1. ensure GNU stow ------
if ! command -v stow >/dev/null; then
  log "1/3 installing GNU stow"
  sudo pacman -S --needed --noconfirm stow
else
  log "1/3 stow $(stow --version 2>&1 | head -1)"
fi

# --------------------------------------- 2. remove old dotfiles -----------
log "2/3 removing old ~/.config/{niri,waybar,fish,kitty,nvim}"
for app in "${APPS[@]}"; do
  rm -rf "$HOME/.config/$app"
done

# ------------------------------------------------- 3. stow from repo ------
log "3/3 stowing ${APPS[*]} -> $HOME/.config"
stow -d "$STOW_DIR" -t "$HOME" -R "${APPS[@]}"

for app in "${APPS[@]}"; do
  printf '  %-7s -> %s\n' "$app" "$(readlink -f "$HOME/.config/$app")"
done

log "done."
