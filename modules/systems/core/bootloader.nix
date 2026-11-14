{ ... }: {
  flake.nixosModules = {
    bootloader = { pkgs, ... }: {
      boot = {
        loader = {
          timeout = 2;
          efi = {
            canTouchEfiVariables = true;
          };
          systemd-boot.enable = true;
          grub = {
            efiSupport = true;
            device = "nodev";
            theme = pkgs.catppuccin-grub;
          };
        };
        # plymouth = {
        #   enable = true;
        #   theme = "catppuccin-mocha";
        #   themePackages = with pkgs; [
        #     catppuccin-plymouth
        #     # (catppuccin-plymouth.override {
        #     #   variant = "mocha";
        #     # })
        #   ];
        # };
        kernelPackages = pkgs.linuxPackages_latest;
      };
    };
  };
}
