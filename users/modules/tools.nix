{
  pkgs,
  ...
}: {
  # Packages for user
  home.packages = with pkgs;
    [
      wireshark
      tcpdump
      iproute2
      gawk
    ];
}
