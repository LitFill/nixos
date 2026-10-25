{
  programs.starship = {
    enable = true;
    enableBashIntegration = false;
    settings = {
      add_newline = true;

      character = {
        success_symbol = "[λ](bold green)";
        error_symbol = "[λ](bold red)";
      };

      format = "$custom $all";
      directory.disabled = true;

      custom = {
        haskell_dir = {
          command = ''
            echo $env.PWD | sed $"s:($env.HOME)::g; s:/: -> :g; s:^ -> ::"
          '';
          # Always run this command
          when = "true";
          format = "[LitFill :: $output]($style)";
          style = "purple"; # You can choose any color/style here
        };

        haskell_tilde = {
          command = "'~'";
          when = "test $env.PWD == $env.HOME";
          format = "[$output]($style)";
          style = "bold purple";
        };
      };
    };
  };
}
