{ ... }: {
  flake.nixosModules = {
    user = { ... }: {
      users.users = {
        litfill = {
          isNormalUser = true;
          description = "LitFill";
          initialPassword = "password";
          extraGroups = [
            "networkmanager"
            "root"
            "wheel"
          ];
        };
      };
    };
  };
}
