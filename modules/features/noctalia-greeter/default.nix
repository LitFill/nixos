{ inputs, ... }:
let
  noctalia-greeter = inputs.noctalia-greeter.nixosModules.default;
in
{
  flake.nixosModules = {
    noctalia-greeter = { pkgs, ... }: {
      imports = [ noctalia-greeter ];

      services.displayManager.noctalia-greeter = {
        enable = true;
        settings = {
          cursor = {
            theme = "Bibata-Modern-Ice";
            size = 24;
            path = pkgs.bibata-cursors;
          };
        };
      };
    };
  };
}
