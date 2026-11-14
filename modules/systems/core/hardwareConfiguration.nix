{ ... }: {
  flake.nixosModules = {
    hardwareConfiguration = { ... }: {
      imports = [ ./_hardware-configuration.nix ];
    };
  };
}
