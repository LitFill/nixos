{ config, ... }:
{
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "https";
      prompt = "enabled";
      prefer_editor_prompt = "disabled";
      aliases = {
        co = "pr checkout";
        cl = "repo clone";
        nw = "repo new";
      };
      color_labels = "disabled";
      accessible_colors = "disabled";
      accessible_prompter = "disabled";
      spinner = "enabled";
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = config.accounts.email.accounts."litfill".realName;
        email = config.accounts.email.accounts."litfill".address;
      };

      init.defaultBranch = "main";

      credential.useHttpPath = true;

      difftool.prompt = false;
      pager.difftool = true;
      pull.ff = "only";

      diff = {
        tool = "difftastic";
      };

      alias = {
        cv = "commit -v";
      };
    };
  };
}
