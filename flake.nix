{
  description = "NixOS config for perihelion";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim.url = "github:nix-community/nixvim";

    autolith.url = "github:lambda-symbolics/autolith";
    koki.url = "github:LitFill/koki";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixvim,
      autolith,
      koki,
      ...
    }:
    let
      hmConfigPath = ./home-manager-config;
      hmFilesPath = ./home-manager-files;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations.perihelion = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit autolith koki; };
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.litfill = import ./users/litfill.nix {
              inherit nixpkgs nixvim;
              lib = nixpkgs.lib;
              hmConfigPath = hmConfigPath;
              hmFilesPath = hmFilesPath;
            };
          }
        ];
      };

      homeConfigurations.litfill = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          nixvim.homeModules.nixvim
          ./users/litfill-hm.nix
        ];
      };
    };
}