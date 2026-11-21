{
  inputs,
  self,
  moduleWithSystem,
  lib,
  ...
}:
let
  inherit (inputs.nixvim.nixosModules) nixvim;
  inherit (inputs.nixvim.lib.nixvim.utils) mkRaw;
in
{
  flake.nixosModules = {
    nixvim = moduleWithSystem (
      { pkgs, ... }:
      let
        inherit (lib) getExe;
      in
      {
        imports = [
          nixvim
          self.nixosModules.fourmolu
        ];

        programs.nixvim = {
          enable = true;
          defaultEditor = true;

          filetype.extension = {
            ua = "uiua";
            kk = "koka";
            io = "io";

            # Neovim already maps .lisp, .lsp, .asd and .cl to the `lisp` filetype;
            # these two Common Lisp extensions it leaves alone.
            sbcl = "lisp";
            ros = "lisp";
          };

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

              trimOnSafe = mkRaw "require('mini.trailspace').trim";

              setupHaskell = mkRaw "SetupHaskell";

              pathCrumb = mkRaw ''
                function()
                  vim.o.winbar = "%!GetShortPath()"
                end
              '';
              signColumn = mkRaw ''
                function()
                  if vim.bo.buftype == "" and vim.wo.signcolumn ~= "yes:2" then
                    vim.opt.signcolumn = "yes:2"
                  end
                end
              '';
              setupIdris2 = mkRaw ''
                function()
                  vim.o.makeprg = "idris2 $*"
                end
              '';
              kebabWords = mkRaw ''
                function()
                  vim.opt_local.iskeyword:append("-")
                end
              '';
              c-like-comment = mkRaw ''
                function()
                  vim.bo.commentstring = "// %s"
                  vim.bo.comments      = "s1:/*,mb:*,ex:*/,://"
                end
              '';
            in
            [
              (mkAuCmd "Trim on save" "BufWritePre" "*" trimOnSafe)
              (mkAuCmd "Setup Haskell" "FileType" [ "haskell" "cabal" "*.hs" "*.cabal" ] setupHaskell)
              (mkAuCmd "Setup Idris 2" "FileType" [ "idris" "idris2" "*.idr" "*.ipkg" ] setupIdris2)
              (mkAuCmd "Path Crumb on winbar" [ "BufEnter" "BufWinEnter" ] "*" pathCrumb)
              (mkAuCmd "Ensure signcolumn is always 'yes:2' in normal buffers" "BufEnter" "*" signColumn)

              # These filetypes use kebab-case identifiers, so `-` counts as a word character
              # and w/b/e (also ciw/diw) stop at real word boundaries instead of every dash.
              (mkAuCmd "Kebab-case word motions" "FileType" [ "koka" "nu" "idris2" "nix" ] kebabWords)

              (mkAuCmd "C-like comments" "FileType" [ "koka" ] c-like-comment)
            ];

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
              #   disable = mkRaw ''
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
                  lua = [ (getExe pkgs.stylua) ];
                  nix = [ (getExe pkgs.nixfmt) ];
                  haskell = [ (getExe self.nixosModules.fourmolu.pkgs.fourmolu) ];
                  rust = [ (getExe pkgs.rustfmt) ];
                  # cpp = [ "clang-format" ];
                  uiua = [ "${getExe pkgs.uiua} fmt" ];
                  toml = [ "${getExe pkgs.taplo} fmt" ];

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
                ] (_: [ (getExe pkgs.prettier) ])
                // lib.genAttrs [ "sh" "bash" ] (_: [ (getExe pkgs.shfmt) ])
                // {

                  "_" = [
                    "trim_whitespace"
                    "squeeze_blanks"
                  ];
                };
              };
            };
          }
          // {
            lsp = {
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
                    (getExe pkgs.idris2Packages.pack)
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
          }
          // {
            rustaceanvim = {
              enable = true;
              settings.server.default_settings.rust-analyzer = {
                checkOnSave = true;
                cargo.features = "all";
                procMacro.enable = true;
              };
            };
          };

          globals = {
            mapleader = " ";
            maplocalleader = " ";

            neovide_opacity = 0.75;
            neovide_normal_opacity = 0.80;
            guifont = "JetBrainsMono NF:h14";

            GetShortPath = mkRaw ''
              function()
                local buf_path = vim.api.nvim_buf_get_name(0)
                if buf_path == "" then
                  return "" -- Jika buffer kosong, tidak tampilkan apa-apa
                end

                local home = vim.fn.expand "$HOME"
                local project_home = home .. "/proyek"

                if buf_path:find("^" .. vim.pesc(project_home)) then
                  buf_path = buf_path:gsub("^" .. vim.pesc(project_home) .. "/", "")
                elseif buf_path:find("^" .. vim.pesc(home)) then
                  buf_path = buf_path:gsub("^" .. vim.pesc(home) .. "/", "")
                end

                local display_path1 = buf_path:gsub("//", "/")
                local display_path = display_path1:gsub("/", " -> ")

                return "%#MiniIconsPurple#  LitFill :: " .. display_path
              end
            '';

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

          lsp = {
            inlayHints.enable = true;
            servers.lua_ls.config = {
              on_init = mkRaw ''
                function(client)
                  if client.workspace_folders then
                    local path = client.workspace_folders[1].name
                    if
                      path ~= vim.fn.stdpath('config')
                      and (vim.uv.fs_stat(path .. '/.luarc.json')
                      or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
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
                      library = { vim.env.VIMRUNTIME }
                    }
                  })
                end'';

              settings = {
                Lua = { };
              };
            };
          };

          keymaps =
            let
              # Command wrapper (e.g., cmd "write" -> "<cmd>write<CR>")
              cmd = str: "<cmd>${str}<CR>";

              nmap = key: action: desc: {
                mode = "n";
                inherit key action;
                options = { inherit desc; };
              };
            in
            [
              # --- General ---
              (nmap "<leader>qw" (cmd "wq") "save and quit")
              (nmap "<C-s>" (cmd "write") "save")
              (nmap "<leader>w" (cmd "write") "save")
              (nmap "<leader>cd" (cmd "Cd") "cd to this file dir")

              # Esc to clear search highlight
              {
                mode = "n";
                key = "<Esc>";
                action = cmd "nohl";
                options = {
                  desc = "No Highlight";
                  silent = true;
                };
              }

              # --- Make ---
              (nmap "<leader>mr" (cmd "make run") "(m)ake (r)un")
              (nmap "<leader>mb" (cmd "make build") "(m)ake (b)uild")
              (nmap "<leader>mqb" (cmd "make build<CR>a") "quick build")

              # --- Editing ---
              (nmap "<leader>rw" ''%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>'' "(r)eplace (w)ord")

              # --- Mini Modules ---
              (nmap "-" (cmd "lua MiniFiles.open()") "Open parent dir")
              (nmap "<leader>pb" (cmd "Pick buffers") "(p)ick (b)uffers")
              (nmap "<leader>pf" (cmd "Pick files") "(p)ick (f)iles")
              (nmap "<leader>ph" (cmd "Pick help") "(p)ick (h)elp")
              (nmap "<leader>:" (cmd "Pick commands") "(p)ick (c)ommand")
              (nmap "<leader>po" (cmd "Pick options") "(p)ick (o)ption")

              # --- Git ---
              (nmap "<leader>gn" (cmd "Neogit") "open NeoGit")

              # --- Terminals ---
              {
                mode = "t";
                key = "<C-q>";
                action = "<C-\\><C-n>";
                options = {
                  desc = "quit terminal";
                  nowait = true;
                };
              }
              (nmap "<leader>ot" (cmd "term<CR>a") "(o)pen (t)erminal")
              (nmap "<leader>vt" (cmd "vs | term<CR>a") "(v)ertical pane (t)erminal")
              (nmap "<leader>st" (cmd "sp | term<CR>a") "horizontal pane (t)erminal")

              # --- Quickfix / Lists ---
              (nmap "<C-k>" (cmd "cnext") "Next quickfix")
              (nmap "<C-j>" (cmd "cprev") "Previous quickfix")
              (nmap "<leader>k" (cmd "lnext") "Next location")
              (nmap "<leader>j" (cmd "lprev") "Previous location")

              # Mode specific exceptions
              {
                mode = "i";
                key = "<C-k>";
                action = "<C-k>";
                options = {
                  desc = "Input Digraph";
                };
              }

              # --- Visual/Motion ---
              {
                mode = [
                  "n"
                  "v"
                ];
                key = "J";
                action = "mzJ`z";
                options = {
                  desc = "shift+j but cursor stays";
                };
              }
              {
                mode = [
                  "n"
                  "v"
                ];
                key = "<leader>d";
                action = ''"_d'';
                options = {
                  desc = "delete no register";
                };
              }
              {
                mode = [
                  "i"
                  "v"
                ];
                key = "kj";
                action = "<Esc>";
                options = {
                  desc = "exit to normal";
                };
              }

              # --- IDRIS 2 KEYMAPS ---
              # REPL (The only one not using code_action)
              (nmap "<leader>iev" (cmd "lua require('idris2.repl').evaluate()") "Idris: evaluate")

              # Code Actions
              (nmap "<leader>ics" (cmd "lua require('idris2.code_action').case_split()") "Idris: case split")
              (nmap "<leader>imc" (cmd "lua require('idris2.code_action').make_case()") "Idris: make case")
              (nmap "<leader>iml" (cmd "lua require('idris2.code_action').make_lemma()") "Idris: make lemma")
              (nmap "<leader>iac" (cmd "lua require('idris2.code_action').add_clause()") "Idris: add clause")
              (nmap "<leader>ies" (cmd "lua require('idris2.code_action').expr_search()")
                "Idris: search expression"
              )
              (nmap "<leader>igd" (cmd "lua require('idris2.code_action').generate_def()")
                "Idris: generate definition"
              )
              (nmap "<leader>irh" (cmd "lua require('idris2.code_action').refine_hole()") "Idris: refine hole")
              (nmap "<leader>iin" (cmd "lua require('idris2.code_action').intro()") "Idris: intro")
              (nmap "<leader>imr" (cmd "make % -o run | !./build/exec/run") "make run for idris2")
              (nmap "<leader>imb" (cmd "make % -o %:h") "make build for idris2")

              # Floating goto-preview
              (nmap "<leader>gpd" (cmd "lua require('goto-preview').goto_preview_definition()")
                "Floating definition preview"
              )
            ];

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

            if not vim.g.neotern then
              require("vim._core.ui2").enable()
            end

            vim.api.nvim_set_hl(0, "MatchParen", { bg = "darkblue" })

            -- matugen theming disabled for now (no themes generated currently)
            -- require "matugen" .setup()

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

            SetupHaskell = function()
              local ht = require "haskell-tools"
              local opt = { buffer = vim.api.nvim_get_current_buf() }
              local set = vim.keymap.set

              local nset = function(key, cmd, opts)
                set("n", key, cmd, opts)
              end

              ---@param desc string
              ---@return { buffer: number, desc: string}
              local desc = function(desc)
                opt.desc = desc
                return opt
              end

              vim.o.makeprg = "cabal $*"

              -- Leader-c mappings untuk Cabal
              nset("<Leader>cb", "<CMD>vs | term cabal build<CR>", desc "Cabal Build")
              nset("<Leader>cr", "<CMD>vs | term cabal run<CR>", desc "Cabal Run")
              nset("<Leader>ct", "<CMD>vs | term cabal test<CR>", desc "Cabal Test")
              nset("<Leader>cc", "<CMD>edit *.cabal<CR>", desc "Open Cabal File")
              nset(
                "<leader>ci",
                "<CMD>vs | term cabal install --installdir=./bin --overwrite-policy=always<CR>",
                desc "Cabal Install in bin directory"
              )

              -- Leader-h mappings untuk Haskell Tools
              nset("<Leader>hh", ht.hoogle.hoogle_signature, desc "Hoogle Search")
              nset("<Leader>hr", ht.repl.toggle, desc "Toggle REPL")
              nset("<Leader>ht", vim.lsp.buf.hover, desc "Show Type Signature")
            end

            GetShortPath = function()
              local buf_path = vim.api.nvim_buf_get_name(0)
              if buf_path == "" then
                return "" -- Jika buffer kosong, tidak tampilkan apa-apa
              end

              local home = vim.fn.expand "$HOME"
              local project_home = home .. "/proyek"

              if buf_path:find("^" .. vim.pesc(project_home)) then
                buf_path = buf_path:gsub("^" .. vim.pesc(project_home) .. "/", "")
              elseif buf_path:find("^" .. vim.pesc(home)) then
                buf_path = buf_path:gsub("^" .. vim.pesc(home) .. "/", "")
              end

              local display_path1 = buf_path:gsub("//", "/")
              local display_path = display_path1:gsub("/", " -> ")

              return "%#MiniIconsPurple#  LitFill :: " .. display_path
            end
          '';

          userCommands.Cd = {
            command = "cd %:h";
            nargs = 0;
            desc = "cd to current opened file";
          };
        };
      }
    );
  };
}
