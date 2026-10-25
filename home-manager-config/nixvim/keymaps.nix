{
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
}
