{ pkgs, kernel ? pkgs.linuxPackages_6_1.kernel }:

pkgs.stdenv.mkDerivation rec {
  pname = "gtp5g";
  version = "0.9.16";

  src = pkgs.fetchFromGitHub {
    owner = "free5gc";
    repo = "gtp5g";
    rev = "v${version}";
    sha256 = "sha256-sCq4Tx0m1hGFl1OLKNGn4N+Ja1sE/UXfwYmgFnHsCa0=";
  };

  nativeBuildInputs = with pkgs; [
    kmod
    gnumake
  ];

  buildInputs = [ kernel.dev ];

  makeFlags = [
    "KVER=${kernel.modDirVersion}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  enableParallelBuilding = true;

  installPhase = ''
    mkdir -p $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net
    cp gtp5g.ko $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/
  '';

  meta = with pkgs.lib; {
    description = "Linux kernel module for 5G GTP-U";
    homepage = "https://github.com/free5gc/gtp5g";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
