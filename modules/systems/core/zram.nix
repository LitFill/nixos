{ ... }: {
  flake.nixosModules = {
    zram = { ... }: {
      # ZRAM swap for memory pressure relief
      zramSwap.enable = true;
    };
  };
}
