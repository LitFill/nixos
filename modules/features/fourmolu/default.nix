{ moduleWithSystem, inputs, ... }: {
  flake.nixosModules = {
    fourmolu = moduleWithSystem (
      { self', ... }: {
        environment.systemPackages = [ self'.packages.fourmolu ];
      }
    );
  };
  perSystem =
    { lib, pkgs, ... }:
    let
      inherit (inputs.wrappers.lib) wrapModule;
      inherit (lib) mkOption;
      inherit (builtins) toJSON;
      fourmoluWrapper = wrapModule (
        {
          config,
          pkgs,
          wlib,
          ...
        }:
        {
          imports = [ wlib.modules.default ];
          options = {
            settings = mkOption {
              inherit (pkgs.formats.yaml { }) type;
              default = { };
              description = "Contents of fourmolu.yaml";
            };
            "fourmolu.yaml" = mkOption {
              type = wlib.types.file {
                path = lib.mkOptionDefault config.constructFiles.fourmolu-config.path;
              };
              default = { };
            };
          };

          config = {
            package = lib.mkDefault pkgs.fourmolu;
            constructFiles.fourmolu-config = {
              relPath = "fourmolu.yaml";
              content = config.settings |> toJSON; # JSON is valid YAML
            };
            flags."--config" = config."fourmolu.yaml".path;
          };
        }
      );
    in
    {
      packages = {
        fourmolu = fourmoluWrapper.wrap {
          inherit pkgs;
          "fourmolu.yaml".path = ./fourmolu.yaml;
        };
      };
    };
}
