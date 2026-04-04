{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    pkgs-unstable = import inputs.nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations = {
      homepc = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs; unstable = pkgs-unstable;};
        modules = [
          ./nixos/homepc/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.vd = import ./users/vd/homepc.nix;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = { inherit inputs; unstable = pkgs-unstable; };
          }
        ];
      };
      mylaptop = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs; unstable = pkgs-unstable;};
        modules = [
          ./nixos/mylaptop/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.vd = import ./users/vd/mylaptop.nix;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = { unstable = pkgs-unstable; };
          }
        ];
      };
      labcoha = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs; unstable = pkgs-unstable;};
        modules = [
          ./nixos/labcoha/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.vd = import ./users/vd/labcoha.nix;
            home-manager.users.lab = import ./users/lab/labcoha.nix;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = { unstable = pkgs-unstable; };
          }
        ];
      };
    };
  };
}
