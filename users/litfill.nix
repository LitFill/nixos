{
  nixpkgs,
  nixvim,
  lib,
  hmConfigPath,
  hmFilesPath,
  ...
}:
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
    nixvim.homeModules.nixvim
    (hmConfigPath + "/git.nix")
    (hmConfigPath + "/shell.nix")
    (hmConfigPath + "/nixvim.nix")
    (hmConfigPath + "/packages.nix")
    (hmConfigPath + "/tmux.nix")
    (hmConfigPath + "/security.nix")
  ];

  home.shell.enableNushellIntegration = true;
  home.sessionPath = [
    "/home/litfill/.local/bin"
    "/home/litfill/.local/share/pnpm"
  ];

  home.file = {
    "stylua.toml".source = hmFilesPath + "/stylua.toml";
    "fourmolu.yaml".source = hmFilesPath + "/fourmolu.yaml";
    ".bash_functions".source = hmFilesPath + "/functions.bash";
    ".ocamlinit".text = ''
      #require "core.top";;
      #require "ppx_jane";;
      open Base;;
    '';
  };

  xdg.configFile = {
    "nushell/functions.nu".source = hmFilesPath + "/functions.nu";
    "nvim/lua/get_short_path.lua".source = hmFilesPath + "/nvim/get_short_path.lua";
    "nvim/lua/setup_haskell.lua".source = hmFilesPath + "/nvim/setup_haskell.lua";
    "nvim/syntax/io.vim".source = hmFilesPath + "/nvim/syntax/io.vim";
  };

  programs.home-manager.enable = true;

  fonts.fontconfig.enable = true;

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    imports = [
      (hmConfigPath + "/nixvim/base.nix")
      (hmConfigPath + "/nixvim/profiles/default.nix")
    ];

    filetype.extension = {
      ua = "uiua";
      kk = "koka";
      io = "io";
      sbcl = "lisp";
      ros = "lisp";
    };
  };
}
