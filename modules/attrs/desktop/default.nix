{ self, moduleWithSystem, ... }: {
  flake.nixosModules = {
    desktop = moduleWithSystem (
      # pkgs,
      { ... }:
      let
        modules = with self.nixosModules; [
          core
          networking
          printing
          graphics
          audio

          nushell
          starship

          # plasmaDE
          # kdeconnect

          umbriel
          noctalia
          noctalia-greeter

          tailscale

          wezterm
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
