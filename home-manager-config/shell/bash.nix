{ ... }:
{
  programs.bash = {
    enable = true;
    enableCompletion = true;

    historyControl = [
      "ignoredups"
      "ignorespace"
    ];
    historySize = 10000;
    historyFileSize = 100000;

    sessionVariables = {
      EDITOR = "nvim";
      RUST_BACKTRACE = "1";
      LEDGER_FILE = "/home/litfill/finance/2026.journal";
      PNPM_HOME = "/home/litfill/.local/share/pnpm";
    };
    # Mirrors the nushell shellAliases, minus nushell-only syntax
    # (nu's `^pass` external calls run directly in bash).
    shellAliases = {
      hms = "home-manager switch";

      g = "git";
      v = "nvim";
      la = "ls -a";
      ls = "ls --color=auto";

      # File Management aliases
      cat = "bat --paging=never --style=header,grid";
      ll = "eza -la --git --icons=auto";
      lt = "eza --tree --git --icons=auto";

      # System information aliases
      top = "btop";
      df = "ncdu";
      du = "ncdu";

      # Quick access tools
      yz = "yazi";
      fm = "yazi";

      # Fuzzy finding
      fz = "fzf";

      # On-demand banner. Nushell prints this at startup; bash does not,
      # because every subshell and tmux pane would pay for it.
      ff = "fastfetch # --iterm /home/litfill/Gambar/ojou-red-flowers-katana.jpg --logo-width 36";

      # Pass aliases
      passgen = "pass generate";
      passotp = "pass otp";
      passls = "pass ls";
      passshow = "pass show";
      passedit = "pass edit";
      passinsert = "pass insert";
      passgrep = "pass grep";
    };

    initExtra = ''
      # vi editing mode, matching nushell's edit_mode = "vi"
      set -o vi

      # Append to the history file instead of clobbering it
      shopt -s histappend

      # GHCup environment (PATH entries already come from home.sessionPath)
      [ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env"

      # broot launcher
      #[ -f "$HOME/.config/broot/launcher/bash/br" ] && source "$HOME/.config/broot/launcher/bash/br"

      # Utility functions, the bash counterparts of files/functions.nu
      # Bash-autosuggestions plugin (gray history-based suggestions)
      [ -f "$HOME/.bash-autosuggestions/bash_autosuggestions.sh" ] || \
        (mkdir -p "$HOME/.bash-autosuggestions" && \
         curl -fsL https://github.com/rcaloras/bash-autosuggestions/raw/master/bash_autosuggestions.sh \
           -o "$HOME/.bash-autosuggestions/bash_autosuggestions.sh")
      [ -f "$HOME/.bash-autosuggestions/bash_autosuggestions.sh" ] && \
        source "$HOME/.bash-autosuggestions/bash_autosuggestions.sh"

      # Utility functions
      [ -f "$HOME/.bash_functions" ] && source "$HOME/.bash_functions"

      # Custom prompt: haskell-style dir, git branch, exit code, λ symbol
      __bash_ps1() {
        local last_exit=$?
        local reset="\[\033[0m\]"
        local purple_bold="\[\033[1;35m\]"
        local green="\[\033[0;32m\]"
        local red="\[\033[0;31m\]"
        local cyan="\[\033[0;36m\]"

        local userhost="$purple_bold\u@\h$reset"
        local haskell_dir
        haskell_dir=$(echo "$PWD" | sed "s|$HOME|~|g; s|/| -> |g; s|^ -> ||g")
        [ -z "$haskell_dir" ] && haskell_dir="~"
        local cwd="$cyan$haskell_dir$reset"

        local git_info=""
        if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
          local branch
          branch=$(git symbolic-ref --short HEAD 2>/dev/null || git describe --tags --exact-match 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
          git_info=" $purple_bold[$branch]$reset"
        fi

        local exit_status=""
        [ $last_exit -ne 0 ] && exit_status=" $red[✘ $last_exit]$reset"

        local prompt_char="$greenλ$reset"
        [ $last_exit -ne 0 ] && prompt_char="$redλ$reset"

        PS1="$userhost $cwd$git_info$exit_status\n$prompt_char "
      }
      PROMPT_COMMAND='__bash_ps1'
    '';
  };
}
