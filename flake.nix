{
  description = "NixOS configuration with i3wm";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { 
        inherit system;
        config.allowUnfree = true;
      };
      
      # Centralized Go version management with custom GOPATH
      # mkGoShell = goVersion: versionName: pkgs.mkShell {
      #   name = "go-${versionName}";
      #
      #   buildInputs = [ goVersion ];
      #
      #   shellHook = ''
      #     # Ensure env directory exists
      #     mkdir -p $HOME/env
      #
      #     # Set custom GOPATH per version
      #     export GOPATH="$HOME/env/go_${versionName}"
      #     export PATH="$GOPATH/bin:$PATH"
      #
      #     # Create GOPATH directories if they don't exist
      #     mkdir -p "$GOPATH"/{bin,pkg,src}
      #
      #     echo ""
      #     echo "╔════════════════════════════════════════╗"
      #     echo "║   Go Development Environment           ║"
      #     echo "╚════════════════════════════════════════╝"
      #     echo ""
      #     echo "Go version: $(go version)"
      #     echo "GOROOT: $(go env GOROOT)"
      #     echo "GOPATH: $GOPATH"
      #     echo ""
      #
      #     if command -v notify-send &> /dev/null; then
      #       notify-send "Go Shell" "Go ${versionName} activated → $GOPATH" -t 3000 2>/dev/null || true
      #     fi
      #   '';
      # };
      
      # Python development environment with isolated pip
      # mkPythonShell = python: versionName: pkgs.mkShell {
      #   name = "python-${versionName}";
      #
      #   buildInputs = [
      #     python
      #     python.pkgs.pip
      #     python.pkgs.virtualenv
      #   ];
      #
      #   shellHook = ''
      #     # Ensure env directory exists
      #     mkdir -p $HOME/env
      #
      #     # Set custom pip install location
      #     export PYTHONUSERBASE="$HOME/env/python_${versionName}"
      #     export PATH="$PYTHONUSERBASE/bin:$PATH"
      #
      #     # Create directories
      #     mkdir -p "$PYTHONUSERBASE"
      #
      #     echo ""
      #     echo "╔════════════════════════════════════════╗"
      #     echo "║   Python Development Environment       ║"
      #     echo "╚════════════════════════════════════════╝"
      #     echo ""
      #     echo "Python version: $(python --version)"
      #     echo "Python path: $(which python)"
      #     echo "Pip install location: $PYTHONUSERBASE"
      #     echo ""
      #     echo "Install packages with: pip install --user <package>"
      #     echo "Or create venv with: python -m venv .venv"
      #     echo ""
      #
      #     if command -v notify-send &> /dev/null; then
      #       notify-send "Python Shell" "Python ${versionName} activated" -t 3000 2>/dev/null || true
      #     fi
      #   '';
      # };
    in
    {
      nixosConfigurations = {
        homepc = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.vd = import ./home.nix;
              home-manager.backupFileExtension = "backup";
            }
          ];
        };
      };

      # devShells.${system} = {
      #   go-1-24 = mkGoShell pkgs.go_1_24 "1.24";
      #   python-3-13 = mkPythonShell pkgs.python313 "3.13";
      # };
    };
}
