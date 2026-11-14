{ ... }: {
  flake.nixosModules = {
    kdeconnect =
      { ... }:
      let
        # Firewall: allow KDE Connect (1714-1764 TCP/UDP)
        kdeconnectPortRange = {
          from = 1714;
          to = 1764;
        };
      in
      {
        programs.kdeconnect.enable = true;

        networking.firewall = {
          enable = true;
          allowedTCPPortRanges = [ kdeconnectPortRange ];
          allowedUDPPortRanges = [ kdeconnectPortRange ];
        };
      };
  };
}
