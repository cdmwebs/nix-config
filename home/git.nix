{ ... }:
{
  programs = {
    git = {
      enable = true;
      settings = {
        user = {
          name = "Chris Moore";
          email = "chris@cdmwebs.com";
        };

        alias = {
          co = "checkout";
          br = "branch";
          st = "status";
          cp = "cherry-pick";
        };

        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        pull.rebase = true;
        diff.colorMoved = "default";
        push.default = "simple";

        # Sign using SSH keys via 1Password. Less trouble than gpg.
        gpg = {
          format = "ssh";
        };
      };
      ignores = [
        ".DS_Store"
        ".irb_history"
      ];
      signing = {
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC4Ma9yQKOx8Rz4d08ejiqejRYhR5aVGyGfBloBTmOeR";
        signByDefault = true;
      };
    };

  };
}
