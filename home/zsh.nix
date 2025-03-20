{ ... }: {
  programs = {
    zsh = {
      enable = true;
      autosuggestion = { enable = true; };
      enableCompletion = true;
      syntaxHighlighting.enable = true;

      sessionVariables = {
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "underline";
        ZSHZ_CASE = "smart";
      };

      initExtraBeforeCompInit = ''
        export CLICOLOR=1
      '';

      initExtra = ''
        list_ssh_fingerprints() {
          for key in ~/.ssh/*.pub; do
            if [[ -f "$key" ]]; then
              fingerprint=$(ssh-keygen -lf "$key")
              echo "$fingerprint ($key)"
            else
              echo "No public keys found in ~/.ssh."
              return 1
            fi
          done
        }
      '';

      shellAliases = {
        l = "ls -lh";
        ll = "ls -lah";
        switch = "darwin-rebuild switch --flake ~/.config/nix#speediest";
        gst = "git status";
        dcu = "mise exec nodejs@20.17 -- devcontainer up --workspace-folder ./";
        dcr =
          "mise exec nodejs@20.17 -- devcontainer up --workspace-folder ./ --remove-existing-container";
        dce =
          "mise exec nodejs@20.17 -- devcontainer exec --workspace-folder ./";
      };

      zplug = {
        enable = true;
        plugins = [
          { name = "agkozak/zsh-z"; }
          { name = "zdharma/fast-syntax-highlighting"; }
          { name = "zsh-users/zsh-completions"; }
          { name = "zsh-users/zsh-autosuggestions"; }
          {
            name = "romkatv/powerlevel10k";
            tags = [ "depth:1" ];
          }
        ];
      };
    };
  };
}
