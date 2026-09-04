{
  pkgs,
  config,
  lib,
  ...
}: {
  # home.packages = with pkgs; [
  #   google-chrome
  # ];
  programs.firefox = {
    enable = true;
    # The Linux hosts have home.stateVersion = 25.11, whose HM default is the
    # legacy ~/.mozilla/firefox — pin the 26.05 XDG path explicitly.
    # On darwin no override is needed: HM defaults to
    # "Library/Application Support/Firefox" and applies policies via defaults
    # (org.mozilla.firefox.plist) automatically.
    configPath = lib.mkIf pkgs.stdenv.hostPlatform.isLinux "${config.xdg.configHome}/mozilla/firefox";
    policies = {
      ExtensionSettings = {
        # Dark Reader
        "addon@darkreader.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
          installation_mode = "force_installed";
          default_area = "navbar";
        };

        # Bitwarden Password Manager
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "force_installed";
          default_area = "navbar";
        };

        # uBlock Origin
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
          default_area = "navbar";
        };

        # Surfshark VPN Proxy
        "{732216ec-0dab-43bb-ac85-4b5e1977599d}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/surfshark-vpn-proxy/latest.xpi";
          installation_mode = "force_installed";
          default_area = "navbar";
        };
      };
    };
  };
}
