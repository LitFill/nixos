{ self, ... }:
let
  inherit (self) nixosModules;
in
{
  flake.nixosModules = {
    core =
      { ... }:
      let
        modules = with nixosModules; [
          user
          bootloader
        ];
      in
      {
        imports = modules;
      };
  };
}
