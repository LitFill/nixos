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

        extra-substituters = [
          "https://umbriel.cachix.org"
          "https://noctalia.cachix.org"
        ];
        extra-trusted-public-keys = [
          "umbriel.cachix.org-1:JfNq/2yg2S6D6z4Z2dVSZrZlDPQTKtexB6GAVLD98nw="
          "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
        ];
      };

      nix.gc = {
        automatic = true;
        dates = "03:00";
      };
    };
  };
}
