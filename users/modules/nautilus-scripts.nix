# Nautilus right-click -> "Scripts" menu: compress selection with
# include/exclude options (zip / tar.gz / tar.zst / 7z).
#
# Installs:
#   ~/.local/share/nautilus/compress-helper      (real logic, live symlink)
#   ~/.local/share/nautilus/scripts/Compress (*) (thin wrappers)
#
# Needs zenity + the archive CLIs, added in nixos/modules/niri.nix.
{
  repoRoot ? "/etc/nixos/nixos-config",
  config,
  lib,
  ...
}: let
  formats = ["zip" "tar.gz" "tar.zst" "7z"];
  wrappers = lib.listToAttrs (map
    (fmt: {
      name = ".local/share/nautilus/scripts/Compress (${fmt})";
      value = {
        executable = true;
        text = ''
          #!/usr/bin/env bash
          exec "$HOME/.local/share/nautilus/compress-helper" "${fmt}"
        '';
      };
    })
    formats);
in {
  home.file = wrappers // {
    ".local/share/nautilus/compress-helper".source =
      config.lib.file.mkOutOfStoreSymlink "${repoRoot}/config/nautilus/compress-helper";
  };
}
