{ pkgs, ... }:
{
  extraPlugins = [
    pkgs.vimPlugins.stay-centered-nvim
    pkgs.vimPlugins.focus-nvim
    pkgs.tree-sitter-grammars.tree-sitter-koka

    # Structural editing for parentheses and sexps: paredit verbs plus
    # drag_pair/form (<p >p <f >f), raise (<localleader>o) and sexp text objects
    # (af if ae ie).
    pkgs.vimPlugins.nvim-paredit

    (pkgs.vimUtils.buildVimPlugin {
      name = "koka-nvim";
      src = pkgs.fetchFromGitHub {
        owner = "syaiful6";
        repo = "koka.nvim";
        rev = "c26bf5cf79cb12019b572ac7434e1d88ea561457";
        hash = "sha256-jyEf9q4tjm+mWAtaC0h/Nd0wSHg2EbZZNPl6RFd2U04=";
      };
    })
  ];

  extraConfigLua = ''
    require "stay-centered" .setup {
        skip_filetypes = {""},
    }

    require "focus" .setup {
        ui = { colorcolumn = { enable = true } }
    }

    -- nvim-paredit ships no plugin/ file, so the keybindings only exist once it
    -- is set up. Its default filetypes already cover `lisp`.
    require("nvim-paredit").setup {}

    -- conjure keeps its config in `vim.g["conjure#..."]` and `merge` refuses to
    -- overwrite keys that already exist unless told to, hence `overwrite?`.
    -- Notifications become a split pane: no HUD, and output wraps instead of
    -- being clipped. Read it with :ConjureLogSplit (ls) or lg.
    require("conjure.config").merge({
      log = {
        hud = { enabled = false },
        split = { height = 0.4 },
        wrap = true
      }
    }, { ["overwrite?"] = true })

    -- local trans = require "transparent"

    -- if vim.g.neovide then
    --     trans.toggle(false)
    -- else
    --     trans.toggle(true)
    -- end

    vim.api.nvim_set_hl(0, "MatchParen", { bg = "darkblue" })

    -- matugen theming disabled for now (no themes generated currently)
    -- require "matugen" .setup()

    require("vim._core.ui2").enable()

    -- conjure's Common Lisp client calls `conjure.log.append` with a bare string
    -- when no swank connection is up, but the log API expects a list of lines.
    -- The client connects on every FileType lisp, so without this every .lisp
    -- buffer opens with an `ipairs` error in the log flush.
    local conjure_log = require "conjure.log"
    local conjure_log_append = conjure_log.append
    conjure_log.append = function(lines, opts)
      return conjure_log_append(type(lines) == "string" and { lines } or lines, opts)
    end

    -- fix for Koka LSP so noisy
    local stock_show_message = vim.lsp.handlers["window/showMessage"]
    vim.lsp.handlers["window/showMessage"] = function(err, params, ctx, config)
      if    params
        and params.message
        and params.message:find("^LspProcessingLog")
        and ctx
        and vim.lsp.get_client_by_id(ctx.client_id).name == "koka"
      then
        return nil
      else
        return stock_show_message(err, params, ctx, config)
      end
    end
  '';

  userCommands.Cd = {
    command = "cd %:h";
    nargs = 0;
    desc = "cd to current opened file";
  };
}
