{
  config,
  pkgs,
  ...
}: {
  home.file = {
    ".config/tmux".source = config.lib.file.mkOutOfStoreSymlink
              "/etc/nixos/nixos-config/config/tmux";
  };

  # Save tmux sessions before shutdown/reboot
  systemd.user.services.tmux-save = {
    Unit = {
      Description = "Save tmux sessions before shutdown";
      DefaultDependencies = false;
      Before = [ "shutdown.target" "reboot.target" "halt.target" "poweroff.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash %h/.config/tmux/tmux-save-restore.sh save";
    };
    Install = {
      WantedBy = [ "shutdown.target" "reboot.target" "halt.target" "poweroff.target" ];
    };
  };
}
