{ self, moduleWithSystem, ... }: {
  flake.nixosModules = {
    desktop = moduleWithSystem (
      { pkgs, ... }:
      let
        modules = with self.nixosModules; [
          core
          networking

          nushell
          starship

          tailscale
        ];
      in
      {
        imports = modules;

        environment.systemPackages = with pkgs; [
          # firefox
          lazygit
        ];
      }
    );
  };
}
