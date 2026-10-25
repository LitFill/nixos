{
  lib,
  # config,
  ...
}:
{
  globals = {
    mapleader = " ";
    maplocalleader = " ";

    neovide_opacity = 0.75;
    neovide_normal_opacity = 0.80;
    guifont = "JetBrainsMono NF:h14";

    GetShortPath = lib.nixvim.utils.mkRaw "require('get_short_path')";

    # Common Lisp block comments (#| ... |#) are invisible to parinfer without
    # this, so unbalanced parens inside them count as real code.
    parinfer_lisp_block_comments = true;
  };

  diagnostic.settings = {
    virtual_lines = {
      current_line = true;
    };
    float = {
      border = "rounded";
      header = "";
      source = true;
    };
    severity_sort = true;
    underline = true;
    update_in_insert = false;
  };

  opts = {
    breakindent = true;
    clipboard = "unnamedplus";
    colorcolumn = "80,120,200";
    cursorline = true;
    expandtab = true;
    ignorecase = true;
    mouse = "a";
    shiftwidth = 4;
    signcolumn = "yes:2";
    smartcase = true;
    smartindent = true;
    splitbelow = true;
    splitright = true;
    tabstop = 4;
    termguicolors = true;
    undofile = true;
    updatetime = 300;
    winborder = "rounded";
    wrap = false;
    exrc = true;
  };

  colorschemes.bamboo.enable = true;
  # colorschemes.base16.enable = true; # for noctalia matugen template (disabled until themes are generated again)
}
