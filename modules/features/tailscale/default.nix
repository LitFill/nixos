{ ... }: {
  flake.nixosModules = {
    tailscale = { ... }: {
      services.tailscale = {
        enable = true;
        useRoutingFeatures = "client"; # "server" kalau mau jadi exit node / subnet router
        openFirewall = true; # buka port UDP 41641
      };

      # Kalau firewall strict (reverse path filtering), kadang perlu:
      networking.firewall.checkReversePath = "loose";
    };
  };
}
