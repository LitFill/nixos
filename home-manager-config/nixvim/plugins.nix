{
  pkgs,
  lib,
  ...
}:
{
  plugins = {
    mini-files = {
      enable = true;
      settings = {
        windows = {
          preview = true;
          width_preview = 60;
        };
        options = {
          use_as_default_explorer = true;
        };
      };
    };
  }
  //
    lib.genAttrs
      [
        "mini-ai"
        "mini-align"
        "mini-bracketed"
        "mini-comment"
        "mini-cursorword"
        "mini-diff"
        "mini-extra"
        "mini-git"
        "mini-icons"
        "mini-indentscope"
        "mini-jump"
        "mini-jump2d"
        "mini-move"
        "mini-notify"
        "mini-operators"
        "mini-pairs"
        "mini-pick"
        "mini-splitjoin"
        "mini-starter"
        "mini-statusline"
        "mini-surround"
        "mini-tabline"
        "mini-trailspace"
      ]
      (name: {
        enable = true;
      })
  // {
    mini-completion.enable = false;

    friendly-snippets.enable = true;
    # transparent.enable = true;
    neogit.enable = true;
    todo-comments.enable = true;
    origami.enable = true;
    rainbow-delimiters.enable = true;

    render-markdown = {
      enable = true;
      settings = {
        code = {
          width = "block";
          right_pad = 1;
        };
      };
    };

    treesitter = {
      enable = true;
      # highlight = {
      #   disable = lib.nixvim.utils.mkRaw ''
      #     function (_, buf)
      #                   local max_filesize = 1000 * 1024
      #                   local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      #                   if ok and stats and stats.size > max_filesize
      #                   then
      #                       return true
      #                   end
      #               end
      #   '';
      # };
      settings = {
        highlight = {
          enable = true;
          additional_vim_regex_highlighting = true;
        };
        indent.enable = true;
      };
      folding.enable = true;

      grammarPackages = [ pkgs.vimPlugins.nvim-treesitter.withAllGrammars ];
    };

    haskell-tools = {
      enable = true;
      settings = {
        hls = {
          default_settings = {
            haskell = {
              formattingProvider = "fourmolu";
              plugin = {
                hlint = {
                  codeActionsOn = true;
                  diagnosticsOn = true;
                };
                importLens = {
                  codeActionsOn = true;
                  codeLensOn = true;
                  globalOn = true;
                };
              };
            };
          };
        };
      };
    };

    idris2.enable = true;

    gitignore.enable = true;
    goto-preview.enable = true;
    indent-o-matic.enable = true;
    # haskell-scope-highlighting.enable = true;
    helpview.enable = true;
    hlchunk.enable = true;
    nix.enable = true;

    ## for LISP
    parinfer-rust.enable = true;
    conjure.enable = true;

    vimwiki = {
      enable = true;
      settings = {
        global_ext = 0;
        list = [
          {
            path = "/home/litfill/vimwiki/";
            syntax = "default";
            ext = ".wiki";
          }
        ];
      };
    };

    blink-cmp = {
      enable = true;
      settings = {
        keymap.preset = "enter";
        signature.enabled = true;
        sources.default = [
          "lsp"
          "path"
          "snippets"
          "buffer"
        ];
        appearance = {
          use_nvim_cmp_as_default = true;
          nerd_font_variant = "mono";
        };
      };
    };

    conform-nvim = {
      enable = true;
      settings = {
        format_on_save = {
          lsp_fallback = true;
          timeout_ms = 500;
        };

        formatters_by_ft = {
          lua = [ "stylua" ];
          nix = [ "nixfmt" ];
          haskell = [ "fourmolu" ];
          rust = [ "rustfmt" ];
          cpp = [ "clang-format" ];
          uiua = [ "uiua fmt" ];
          toml = [ "taplo fmt" ];
          odin = [ "ols fmt" ];

        }
        // lib.genAttrs [
          "javascript"
          "typescript"
          "javascriptreact"
          "typescriptreact"
          "html"
          "css"
          "scss"
          "json"
          "jsonc"
          "markdown"
          "yaml"
        ] (_: [ "prettier" ])
        // lib.genAttrs [ "sh" "bash" ] (_: [ "shfmt" ])
        // {

          "_" = [
            "trim_whitespace"
            "squeeze_blanks"
          ];
        };
      };
    };
  };
}
