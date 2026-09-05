{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Darwin (macOS) host — darwin-flavored nixpkgs + nix-darwin
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
    ...
  }: let
    system = "x86_64-linux";
  in {
    nixosConfigurations = {
      homepc = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./nixos/homepc/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.vd = import ./users/vd/homepc.nix;
            home-manager.backupFileExtension = "backup";
            # Absolute path of this repo on the host; user modules use it for
            # their mkOutOfStoreSymlink config links
            home-manager.extraSpecialArgs.repoRoot = "/etc/nixos/nixos-config";
          }
        ];
      };
      mylaptop = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./nixos/mylaptop/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.vd = import ./users/vd/mylaptop.nix;
            home-manager.backupFileExtension = "backup";
            # Absolute path of this repo on the host; user modules use it for
            # their mkOutOfStoreSymlink config links
            home-manager.extraSpecialArgs.repoRoot = "/etc/nixos/nixos-config";
          }
        ];
      };
      myserver = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./nixos/myserver/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.vd = import ./users/vd/myserver.nix;
            home-manager.backupFileExtension = "backup";
            # Absolute path of this repo on the host; user modules use it for
            # their mkOutOfStoreSymlink config links
            home-manager.extraSpecialArgs.repoRoot = "/etc/nixos/nixos-config";
          }
        ];
      };
    };

    # MacBook (macOS) — bootstrap on the Mac with:
    #   sudo nix run nix-darwin/nix-darwin-26.05#darwin-rebuild -- switch --flake .#macvd
    darwinConfigurations = {
      macvd = nix-darwin.lib.darwinSystem {
        modules = [
          ./darwin/macvd/configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.lvdund = import ./users/lvdund/macvd.nix;
            home-manager.backupFileExtension = "backup";
            # Where the repo is cloned on the Mac; user modules use it for
            # their mkOutOfStoreSymlink config links
            home-manager.extraSpecialArgs.repoRoot = "/Users/lvdund/nixos-config";
          }
        ];
      };
    };
  };
}
