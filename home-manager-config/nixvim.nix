{ lib, ... }:
{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;

    imports = [
      ./nixvim/base.nix
      ./nixvim/profiles/default.nix
    ];

    filetype.extension = {
      ua = "uiua";
      kk = "koka";
      io = "io";

      # Neovim already maps .lisp, .lsp, .asd and .cl to the `lisp` filetype;
      # these two Common Lisp extensions it leaves alone.
      sbcl = "lisp";
      ros = "lisp";
    };
  };
}
