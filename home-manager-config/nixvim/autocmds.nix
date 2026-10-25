{ lib, ... }:
{
  autoCmd =
    let
      mkAuCmd = desc: event: pattern: callback: {
        inherit
          desc
          event
          pattern
          callback
          ;
      };

      trimOnSafe = lib.nixvim.utils.mkRaw "require('mini.trailspace').trim";

      setupHaskell = lib.nixvim.utils.mkRaw "require('setup_haskell')";
      pathCrumb = lib.nixvim.utils.mkRaw ''
        function()
            vim.o.winbar = "%!g:GetShortPath()"
        end
      '';
      signColumn = lib.nixvim.utils.mkRaw ''
        function()
            if vim.bo.buftype == "" and vim.wo.signcolumn ~= "yes:2" then
                vim.opt.signcolumn = "yes:2"
            end
        end
      '';
      setupIdris2 = lib.nixvim.utils.mkRaw ''
        function()
            vim.o.makeprg = "idris2 $*"
        end
      '';
      kebabWords = lib.nixvim.utils.mkRaw ''
        function()
            vim.opt_local.iskeyword:append("-")
        end
      '';
    in
    [
      (mkAuCmd "Trim on save" "BufWritePre" "*" trimOnSafe)
      (mkAuCmd "Setup Haskell" "FileType" [ "haskell" "cabal" "*.hs" "*.cabal" ] setupHaskell)
      (mkAuCmd "Setup Idris 2" "FileType" [ "idris" "idris2" "*.idr" "*.ipkg" ] setupIdris2)

      # These filetypes use kebab-case identifiers, so `-` counts as a word character
      # and w/b/e (also ciw/diw) stop at real word boundaries instead of every dash.
      (mkAuCmd "Kebab-case word motions" "FileType" [ "koka" "nu" "idris2" "nix" ] kebabWords)
      (mkAuCmd "Path Crumb on winbar" [ "BufEnter" "BufWinEnter" ] "*" pathCrumb)
      (mkAuCmd "Ensure signcolumn is always 'yes:2' in normal buffers" "BufEnter" "*" signColumn)
    ];
}
