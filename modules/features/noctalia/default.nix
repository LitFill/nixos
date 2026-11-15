{ inputs, ... }:
let
  noctalia = inputs.noctalia.nixosModules.default;
in
{
  flake.nixosModules = {
    noctalia = { ... }: {
      imports = [ noctalia ];

      networking.networkmanager.enable = true;
      hardware.bluetooth.enable = true;
      services = {
        power-profiles-daemon.enable = true;
        upower.enable = true;
      };

      programs.noctalia = {
        enable = true;
        recommendedServices.enable = true;
        systemd.enable = true;
      };
    };
  };
}
