{ ... }: {
  flake.nixosModules = {
    hostConfiguration = { pkgs, ... }: {
      networking.hostName = "perihelion";
      time.timeZone = "Asia/Jakarta";
      i18n.defaultLocale = "id_ID.UTF-8";

      environment.systemPackages = with pkgs; [
        git
      ];
    };
  };
}
