{ inputs, self, ... }:
let
  inherit (inputs.nixpkgs.lib) nixosSystem;
  inherit (self) nixosModules;
in
{
  flake.nixosConfigurations = {
    perihelion = nixosSystem {
      modules = with nixosModules; [
        hostConfiguration
        hardwareConfiguration
        desktop
      ];
    };
  };
}
