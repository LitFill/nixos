{ ... }: {
  flake.nixosModules = {
    user = { ... }: {
      users.users = {
        litfill = {
          isNormalUser = true;
          initialPassword = "password";
          extraGroups = [
            "root"
            "wheel"
          ];
        };
      };
    };
  };
}
