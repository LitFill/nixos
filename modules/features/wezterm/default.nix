{ inputs, moduleWithSystem, ... }: {
  flake.nixosModules = {
    wezterm = moduleWithSystem (
      { self', ... }:
      let
        wezterm = self'.packages.wezterm;
      in
      {
        environment.systemPackages = [ wezterm ];
      }
    );
  };
  perSystem =
    { pkgs, ... }:
    let
      inherit (inputs.wrappers.wrappers.wezterm) wrap;
    in
    {
      packages = {
        wezterm = wrap {
          inherit pkgs;
          "wezterm.lua".path = ./wezterm.lua;
        };
      };
    };
}
