{ moduleWithSystem, inputs, ... }: {
  flake.nixosModules = {
    nushell = moduleWithSystem (
      { self', ... }:
      let
        nu = self'.packages.nushell;
      in
      {
        environment = {
          systemPackages = [ nu ];
          shells = [ nu ];
        };
      }
    );
  };
  perSystem =
    {
      lib,
      pkgs,
      ...
    }:
    let
      inherit (inputs.wrappers.wrappers.nushell) wrap;
      inherit (lib)
        concatStringsSep
        filterAttrs
        getExe
        mapAttrsToList
        mkBefore
        mkOption
        pipe
        types
        ;

      aliasModule = { config, ... }: {
        options.nushellAliases = mkOption {
          type = with types; attrsOf (nullOr str);
          default = { };
          description = "Alias nushell: nama -> perintah. Nilai null diabaikan";
        };
        config."config.nu".content = mkBefore (
          config.nushellAliases
          |> (filterAttrs (_: cmd: cmd != null))
          |> (mapAttrsToList (name: cmd: "alias ${name} = ${cmd}"))
          |> (concatStringsSep "\n")

        );
      };
    in
    {
      packages = {
        nushell = wrap {
          inherit pkgs;
          imports = [ aliasModule ];

          "config.nu".content = /* nu */ ''
            source ${./functions.nu}
          '';

          nushellAliases = {
            g = getExe pkgs.git;
            v = getExe pkgs.neovim;
            la = "ls -a";

            # File Management aliases
            ll = "${getExe pkgs.eza} -la --git --icons";
            lt = "${getExe pkgs.eza} --tree --git --icons";
            cat = "${getExe pkgs.bat} --paging=never --style=header,grid";
            grep = "${getExe pkgs.ripgrep} --pretty";
            # find = getExe pkgs.fd;

            # System information aliases
            top = getExe pkgs.btop;
            df = getExe pkgs.ncdu;
            # du = getExe pkgs.ncdu;

            # Quick access tools
            yz = getExe pkgs.yazi;
            fm = getExe pkgs.yazi;

            # Fuzzy finding
            fz = getExe pkgs.fzf;
          };
        };
      };
    };
}
