{ self, ... }:
let
  inherit (self) nixosModules;
in
{
  flake.nixosModules = {
    plasmaDE =
      {
        # pkgs,
        ...
      }:
      {
        imports = with nixosModules; [
          sddm
          pipewire
        ];

        services.desktopManager.plasma6.enable = true;

        # opsional: buang aplikasi KDE yang tidak dipakai
        # environment.plasma6.excludePackages = with pkgs.kdePackages; [
        #   elisa
        #   khelpcenter
        # ];
      };
  };
}
