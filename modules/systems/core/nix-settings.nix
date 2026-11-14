{ ... }: {
  flake.nixosModules = {
    nix-settings = {
      nix.settings = {
        extra-experimental-features = [
          "nix-command"
          "flakes"
          "pipe-operators"
        ];

        trusted-users = [
          "root"
          "litfill"
        ];
      };

      nix.gc = {
        automatic = true;
        dates = "03:00";
      };
    };
  };
}
