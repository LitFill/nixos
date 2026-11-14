{ ... }: {
  flake.nixosModules = {
    networking = { ... }: {
      networking = {
        networkmanager = {
          enable = true;
          dns = "none";
        };
        nameservers = [
          "1.1.1.1"
          "8.8.8.8"
        ];
        # firewall.enable = false;
      };

      systemd.services = {
        NetworkManager-wait-online.enable = false;
      };
    };
  };
}
