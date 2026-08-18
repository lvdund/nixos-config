#!/usr/bin/env bash
# arch_install.sh — post-install setup for mylaptop (minimal Arch is already installed)
#
# Usage (as root, right after first boot into minimal Arch):
#   sudo ./arch_install.sh [repo-dir]     # default repo: /home/vd/nixos-config
#
# What it does (and nothing else):
#   1. install packages (paru)
#   2. fcitx5 config (IM env vars)
#   3. code: golang GOPATH/GOROOT + PATH, nvim config symlink from repo
#   4. sysctl: socket buffer caps/defaults + SCTP memory tuning

set -euo pipefail

USERNAME="vd"
REPO_DIR_DEFAULT="/home/$USERNAME/nixos-config"

log()  { printf '\033[1;32m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33mWARN:\033[0m %s\n' "$*"; }
die()  { printf '\033[1;31mERROR:\033[0m %s\n' "$*" >&2; exit 1; }

# --------------------------------------------------------------- packages --
PKGS=(
  # core utilities + compression
  fzf fd bat ripgrep lsd wget curl net-tools
  iptables gcc make kmod btop tmux zip unzip p7zip unrar
  # desktop: niri (wayland) stack
  niri xorg-xwayland greetd greetd-tuigreet waybar mako rofi-wayland fuzzel
  swaylock swayidle grim slurp wl-clipboard
  xdg-desktop-portal-gnome xdg-desktop-portal-gtk polkit-gnome
  pipewire pipewire-pulse pipewire-alsa wireplumber rtkit pavucontrol
  nautilus gvfs tumbler dconf gnome-themes-extra lxappearance fuse2 libarchive
  # fonts
  ttf-firacode-nerd
  # ttf-nerd-fonts-symbols noto-fonts noto-fonts-cjk noto-fonts-emoji
  # input method
  fcitx5-im fcitx5-unikey
  # apps
  libnotify ffmpeg kitty zathura zathura-pdf-mupdf vlc brightnessctl
  sshfs file-roller openssl pciutils lksctp-tools
  # code: golang + dev tools
  go neovim lazygit lazydocker git-delta delve golangci-lint pyright
  stylua python-black lua-language-server jq direnv yazi fish
)

# ========================================================= 1. install pkgs ==
install_pkgs() {
  log "1/4 installing ${#PKGS[@]} packages (paru)"
  paru -Syu --needed --noconfirm "${PKGS[@]}"
  chsh -s /bin/fish "$USERNAME"
}

# ============================================================ 2. fcitx5 ====
setup_fcitx5() {
  log "2/4 fcitx5 env vars -> /etc/environment"
  local f=/etc/environment
  touch "$f"
  for var in GTK_IM_MODULE=fcitx QT_IM_MODULE=fcitx 'XMODIFIERS=@im=fcitx'; do
    grep -qxF "$var" "$f" || echo "$var" >>"$f"
  done
  # fcitx5 itself is started by the compositor: add to niri config.kdl:
  #   spawn-at-startup "fcitx5"
}

# ================================================ 3. code: golang + nvim ===
setup_code() {
  local repo="${1:-$REPO_DIR_DEFAULT}"
  log "3/4 code setup (golang GOPATH/GOROOT, nvim config)"

  if [[ ! -d $repo ]]; then
    warn "repo not found at $repo — pass repo dir as arg 1; skipping nvim symlink"
  fi

  runuser -u "$USERNAME" -- bash <<EOF
set -e
# golang env (was users/modules/code.nix)
mkdir -p "\$HOME/env/gopath_main"/{bin,pkg,src}
mkdir -p "\$HOME/.config/fish"

cfg="\$HOME/.config/fish/config.fish"
touch "\$cfg"
if ! grep -q 'arch_install.sh' "\$cfg"; then
  cat >>"\$cfg" <<'FISH'
# --- arch_install.sh: golang ---
set -gx GOPATH ~/env/gopath_main
set -gx GOROOT /usr/lib/go
fish_add_path -g ~/env/gopath_main/bin
FISH
fi

# nvim config from this repo
[[ -d "$repo" ]] && ln -sfn "$repo/config/nvim" "\$HOME/.config/nvim"
EOF
}

# ======================================================== 4. sysctl tuning ==
setup_sysctl() {
  log "4/4 sysctl: socket buffers + SCTP memory -> /etc/sysctl.d/99-tuning.conf"
  cat >/etc/sysctl.d/99-tuning.conf <<'EOF'
# Global socket buffer caps/defaults
net.core.rmem_max = 8388608
net.core.wmem_max = 8388608
net.core.rmem_default = 8388608
net.core.wmem_default = 8388608

# SCTP-specific memory tuning
net.sctp.sctp_rmem = 4096 262144 8388608
net.sctp.sctp_wmem = 4096 262144 8388608
EOF

  # net.sctp.* only exists once the module is loaded — load it at boot
  echo sctp >/etc/modules-load.d/sctp.conf
  modprobe sctp || true
  sysctl --system >/dev/null
}

# ------------------------------------------------------------------ main ---
main() {
  [[ $EUID -eq 0 ]] || die "run as root: sudo $0 [repo-dir]"
  command -v paru &>/dev/null || die "paru not found — run arch_pre_install.sh first"
  install_pkgs
  setup_fcitx5
  setup_code "${1:-}"
  setup_sysctl

  log "done."
  log "next: log in as $USERNAME (fish) — GOPATH/GOROOT set, nvim config linked."
  log "add 'spawn-at-startup \"fcitx5\"' to niri config.kdl for the input method."
}

main "$@"
