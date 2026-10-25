{ config, ... }:
{
  home.username = "litfill";
  home.homeDirectory = "/home/litfill";
  home.stateVersion = "26.05";

  accounts.email.accounts.litfill = {
    primary = true;
    realName = "LitFill";
    address = "marrazzy54@gmail.com";
  };

  imports = [
    ../home-manager-config/git.nix
    ../home-manager-config/shell.nix
    ../home-manager-config/nixvim.nix
    ../home-manager-config/packages.nix
    ../home-manager-config/tmux.nix
    ../home-manager-config/security.nix
  ];

  home.shell.enableNushellIntegration = true;
  home.sessionPath = [
    "/home/litfill/.local/bin"
    "/home/litfill/.local/share/pnpm"
  ];

  home.file = {
    "stylua.toml".source = ../home-manager-files/stylua.toml;
    "fourmolu.yaml".source = ../home-manager-files/fourmolu.yaml;
    ".bash_functions".source = ../home-manager-files/functions.bash;
    ".ocamlinit".text = ''
      #require "core.top";;
      #require "ppx_jane";;
      open Base;;
    '';
  };

  xdg.configFile = {
    "nushell/functions.nu".source = ../home-manager-files/functions.nu;
    "nvim/lua/get_short_path.lua".source = ../home-manager-files/nvim/get_short_path.lua;
    "nvim/lua/setup_haskell.lua".source = ../home-manager-files/nvim/setup_haskell.lua;
    "nvim/syntax/io.vim".source = ../home-manager-files/nvim/syntax/io.vim;
  };

  programs.home-manager.enable = true;

  fonts.fontconfig.enable = true;
}
