{ inputs, ... }:
let
  umbriel = inputs.umbriel.nixosModules.default;
in
{
  flake.nixosModules = {
    umbriel = { ... }: {
      imports = [ umbriel ];

      programs.umbriel.enable = true;
    };
  };
}
