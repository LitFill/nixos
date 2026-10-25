{
  lib,
  pkgs,
  ...
}:
{
  lsp = {
    inlayHints.enable = true;
    servers.lua_ls.config = {
      on_init = lib.nixvim.utils.mkRaw ''
        function(client)
                  if client.workspace_folders then
                      local path = client.workspace_folders[1].name
                      if
                          path ~= vim.fn.stdpath('config')
                          and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
                      then return
                      end
                  end

                  client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                      runtime = {
                          -- Tell the language server which version of Lua you're using (most
                          -- likely LuaJIT in the case of Neovim)
                          version = 'LuaJIT',
                          -- Tell the language server how to find Lua modules same way as Neovim
                          -- (see `:h lua-module-load`)
                          path = {
                              'lua/?.lua',
                              'lua/?/init.lua',
                          },
                      },
                      -- Make the server aware of Neovim runtime files
                      workspace = {
                          checkThirdParty = false,
                          library = {
                              vim.env.VIMRUNTIME
                          }
                      }
                  })
              end'';

      settings = {
        Lua = { };
      };
    };
  };

  plugins.lsp = {
    enable = true;
    keymaps = {
      silent = true;
      lspBuf = {
        gd = "definition";
        gD = "declaration";
        K = "hover";
        gi = "implementation";
        "<leader>rn" = "rename";
        "<leader>ca" = "code_action";
      };
    };
    servers = {
      bashls.enable = true;
      astro = {
        enable = false;
        extraOptions = {
          init_options = {
            typescript = {
              tsdk = "${pkgs.typescript}/lib/node_modules/typescript/lib";
            };
          };
        };
      };
      # clangd.enable = true;
      lua_ls.enable = true;
      # ocamllsp.enable = true;
      nixd.enable = true;
      nushell.enable = true;
      sqls.enable = true;

      uiua.enable = true;
      uiua.filetypes = [ "uiua" ];

      # No Common Lisp server here on purpose: nixpkgs packages neither
      # cl-lsp nor swank-lsp, and nixvim's c3_lsp is the C3 language server,
      # not Common Lisp. REPL access comes from conjure talking to the swank
      # backend in `nix develop`.

      taplo.enable = true;

      idris2_lsp = {
        enable = false;
        # Memaksa LSP dijalankan melalui pack
        cmd = [
          "pack"
          "exec"
          "idris2-lsp"
        ];
      };

      # ESLint LSP Server untuk JavaScript/TypeScript
      eslint = {
        enable = true;
        filetypes = [
          "javascript"
          "javascriptreact"
          "typescript"
          "typescriptreact"
          "vue"
          "svelte"
        ];
        settings = {
          codeAction = {
            disableRuleComment = {
              enable = true;
              location = "separateLine";
            };
            showDocumentation = {
              enable = true;
            };
          };
          codeActionOnSave = {
            enable = true;
            mode = "all";
          };
          format = false;
          nodePath = "";
          quiet = false;
          rulesCustomizations = { };
          run = "onType";
          validate = "on";
          workingDirectory = {
            mode = "location";
          };
        };
      };

      # Stylelint LSP Server untuk CSS/SCSS
      stylelint_lsp = {
        enable = true;
        filetypes = [
          "css"
          "scss"
          "less"
          "sass"
          "stylus"
          "vue"
          "svelte"
        ];
        cmd = [
          "${pkgs.stylelint-lsp}/bin/stylelint-lsp"
          "--stdio"
        ];
        settings = {
          stylelintplus = {
            autoFixOnFormat = true;
            autoFixOnSave = true;
            cssInJs = {
              injectedLanguages = [
                "javascript"
                "typescript"
              ];
            };
          };
        };
      };

      jsonls = {
        enable = true;
        filetypes = [
          "json"
          "jsonc"
        ];
        settings = {
          json = {
            validate = {
              enable = true;
            };
            schemas =
              map
                ({ pattern, url }: {
                  fileMatch = [ pattern ];
                  inherit url;
                })
                [
                  {
                    pattern = "package.json";
                    url = "https://json.schemastore.org/package";
                  }
                  {
                    pattern = "tsconfig*.json";
                    url = "https://json.schemastore.org/tsconfig";
                  }
                  {
                    pattern = "jsconfig*.json";
                    url = "https://json.schemastore.org/jsconfig";
                  }
                  {
                    pattern = ".eslintrc.json";
                    url = "https://json.schemastore.org/eslintrc";
                  }
                  {
                    pattern = "prettierrc.json";
                    url = "https://json.schemastore.org/prettierrc";
                  }
                  {
                    pattern = ".stylelintrc.json";
                    url = "https://json.schemastore.org/stylelintrc";
                  }
                  {
                    pattern = "babel.config.json";
                    url = "https://json.schemastore.org/babelrc";
                  }
                ];
          };
        };
      };

      # Rust (Standard setup)
      # rust_analyzer = {
      #     enable = true;
      #     installCargo = true;
      #     installRustc = true;
      # };
    };
  };

  plugins.rustaceanvim = {
    enable = true;
    settings.server.default_settings.rust-analyzer = {
      checkOnSave = true;
      cargo.features = "all";
      procMacro.enable = true;
    };
  };
}
