{
  description = "Home Manager configuration for Arch Linux with i3wm";

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
      homeConfigurations = {
        vd = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./configuration.nix
          ];
        };
      };
    };
}
