{ ... }: {
  programs = {
    git = {
      enable = true;
      userName = "Chris Moore";
      userEmail = "chris@cdmwebs.com";
      aliases = {
        co = "checkout";
        br = "branch";
        st = "status";
        cp = "cherry-pick";
      };
      ignores = [ ".DS_Store" ".irb_history" ];
      signing = {
        key =
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC4Ma9yQKOx8Rz4d08ejiqejRYhR5aVGyGfBloBTmOeR";
        signByDefault = true;
      };
      extraConfig = {
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        pull.rebase = true;
        diff.colorMoved = "default";
        push.default = "simple";

        # Sign using SSH keys via 1Password. Less trouble than gpg.
        gpg = {
          format = "ssh";
          ssh.program =
            "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
        };
      };
    };

  };
}
