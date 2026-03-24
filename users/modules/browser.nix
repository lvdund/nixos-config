{pkgs, ...}: {
  programs.firefox = {
    enable = true;
    policies = {
      ExtensionSettings = {
        # Catppuccin Mocha Lavender
        # "{8446b178-c865-4f5c-8ccc-1d7887811ae3}" = {
        #   install_url = "https://addons.mozilla.org/firefox/downloads/latest/catppuccin-mocha-lavender-git/latest.xpi";
        #   installation_mode = "force_installed";
        # };

        # Dark Reader
        "addon@darkreader.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
          installation_mode = "force_installed";
          default_area = "navbar";
        };

        # Bitwarden
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
      };
    };
  };
}
