{
  # config,
  # pkgs,
  ...
}: {
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking = {
    networkmanager.enable = true;
    firewall.enable = false;
  };

  # Let NetworkManager handle DNS with default settings
  # This is more reliable than strict DNSSEC + DoT which can fail
  # on some networks/ISPs that don't fully support them.
  #
  # If you want DNS-over-TLS with fallback in the future, use:
  # networking.networkmanager.dns = "systemd-resolved";
  # services.resolved = {
  #   enable = true;
  #   dnssec = "allow-downgrade";
  #   fallbackDns = ["1.1.1.1" "8.8.8.8"];
  #   extraConfig = ''
  #     DNSOverTLS=opportunistic
  #   '';
  # };
}
