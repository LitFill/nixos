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
          nix-settings
          zram
        ];
      in
      {
        imports = modules;
      };
  };
}
