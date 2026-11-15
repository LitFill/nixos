{ self, moduleWithSystem, ... }: {
  flake.nixosModules = {
    desktop = moduleWithSystem (
      # pkgs,
      { ... }:
      let
        modules = with self.nixosModules; [
          core
          networking

          nushell
          starship

          # plasmaDE
          # kdeconnect

          umbriel
          noctalia
          noctalia-greeter

          tailscale
        ];
      in
      {
        imports = modules;

        environment.systemPackages = # with pkgs;
          [ ];
      }
    );
  };
}
