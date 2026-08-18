{ config, ... }:
{
  programs = {
    zsh = {
      enable = true;
      dotDir = config.home.homeDirectory;
      autosuggestion = {
        enable = true;
      };
      enableCompletion = true;
      syntaxHighlighting.enable = true;

      sessionVariables = {
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "underline";
        ZSHZ_CASE = "smart";
      };

      profileExtra = ''
        # OrbStack command-line tools and integration
        source "$HOME/.orbstack/shell/init.zsh" 2>/dev/null || :
        export PATH="/opt/homebrew/opt/node@22/bin:$PATH"
      '';

      initContent = ''
        export CLICOLOR=1
        export PATH="$HOME/.mtplx/bin:$PATH"

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

        [[ -f "$HOME/.config/zsh/private.zsh" ]] && source "$HOME/.config/zsh/private.zsh"
      '';

      shellAliases = {
        l = "ls -lh";
        ll = "ls -lah";
        gst = "git status";
        dcu = "mise exec nodejs@20.17 -- devcontainer up --workspace-folder ./";
        dcr = "mise exec nodejs@20.17 -- devcontainer up --workspace-folder ./ --remove-existing-container";
        dce = "mise exec nodejs@20.17 -- devcontainer exec --workspace-folder ./";
      };

      zplug = {
        enable = true;
        plugins = [
          { name = "agkozak/zsh-z"; }
          # Pure prompt
          { name = "mafredri/zsh-async"; }
          {
            name = "sindresorhus/pure";
            tags = [
              "use:pure.zsh"
              "as:theme"
            ];
          }
        ];
      };
    };
  };
}
