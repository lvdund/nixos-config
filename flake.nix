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
    in
    {
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
            }
          ];
        };
      };
    };
}
