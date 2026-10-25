{ config, pkgs, ... }:
{
  # Password manager with pass
  programs.password-store.enable = true;

  # Password management tools included in main packages

  # GPG configuration
  programs.gpg = {
    enable = true;
    homedir = "${config.home.homeDirectory}/.gnupg";
  };

  # Git integration for pass
  programs.git.settings = {
    gpg = {
      program = "${pkgs.gnupg}/bin/gpg";
    };
  };
}
