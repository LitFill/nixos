{ ... }: {
  flake.nixosModules = {
    ssh = { ... }: {
      # Enable the OpenSSH daemon.
      services.openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = false;
          PermitRootLogin = "no";
          ChallengeResponseAuthentication = false;
          UsePAM = false;
          KbdInteractiveAuthentication = false;
        };
      };
    };
  };
}
