{ ... }: {
  flake.nixosModules = {
    hostConfiguration = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [
        git
      ];
    };
  };
}
