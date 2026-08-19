#!/usr/bin/env bash
# arch_install.sh — post-install setup for mylaptop (minimal Arch is already installed)
#
# Usage (as root, right after first boot into minimal Arch):
#   sudo ./arch_install.sh
#
# What it does (and nothing else):
#   1. install packages (paru)
#   2. greetd → tuigreet → niri-session
#   3. sysctl: socket buffer caps/defaults + SCTP memory tuning

set -euo pipefail

log() { printf '\033[1;32m==>\033[0m %s\n' "$*"; }
die() { printf '\033[1;31mERROR:\033[0m %s\n' "$*" >&2; exit 1; }

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
  thunar thunar-archive-plugin thunar-volman gvfs tumbler fuse2 libarchive
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
  log "1/3 installing ${#PKGS[@]} packages (paru)"
  paru -Syu --needed --noconfirm "${PKGS[@]}"
}

# ============================================ 2. greetd → niri ===
setup_greetd() {
  log "2/3 greetd: tuigreet -> niri-session"

  mkdir -p /etc/greetd
  cat >/etc/greetd/config.toml <<'TOML'
[terminal]
vt = 1

[default_session]
command = "tuigreet --time --cmd niri-session"
user = "greeter"
TOML

  systemctl enable greetd.service
}

# ======================================================== 3. sysctl tuning ==
setup_sysctl() {
  log "3/3 sysctl: socket buffers + SCTP memory -> /etc/sysctl.d/99-tuning.conf"
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
  [[ $EUID -eq 0 ]] || die "run as root: sudo $0"
  command -v paru &>/dev/null || die "paru not found — run arch_pre_install.sh first"
  install_pkgs
  setup_greetd
  setup_sysctl

  log "done."
  log "next: reboot — tuigreet will launch niri-session automatically."
}

main