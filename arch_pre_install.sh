#!/usr/bin/env bash
# arch_pre_install.sh — make vd passwordless admin + install paru
#
# Usage:  sudo ./arch_pre_install.sh

set -euo pipefail

USERNAME="vd"

log() { printf '\033[1;32m==>\033[0m %s\n' "$*"; }
die() { printf '\033[1;31mERROR:\033[0m %s\n' "$*" >&2; exit 1; }

[[ $EUID -eq 0 ]] || die "run as root: sudo $0"

# ======================================================== vd: passwordless admin ==
if id "$USERNAME" &>/dev/null; then
  log "user '$USERNAME' exists"
else
  useradd -m -G wheel -s /bin/bash "$USERNAME"
  log "set password for $USERNAME"
  passwd "$USERNAME"
fi

# extra groups (only those that exist on this system)
for g in networkmanager video audio docker; do
  getent group "$g" >/dev/null && usermod -aG "$g" "$USERNAME"
done

cat >/etc/sudoers.d/"$USERNAME" <<EOF
$USERNAME ALL=(ALL) NOPASSWD: SETENV: ALL
EOF
chmod 440 /etc/sudoers.d/"$USERNAME"
visudo -cf /etc/sudoers.d/"$USERNAME"

# ================================================================ install paru ==
if command -v paru &>/dev/null; then
  log "paru already installed, done"
  exit 0
fi

log "building paru-bin from AUR as $USERNAME"
pacman -S --needed --noconfirm base-devel git
su - "$USERNAME" -c '
  set -e
  cd /tmp
  git clone https://aur.archlinux.org/paru-bin.git
  cd paru-bin
  makepkg --noconfirm
'
pacman -U --noconfirm /tmp/paru-bin/paru-bin-*.pkg.tar.zst
rm -rf /tmp/paru-bin

log "done."
