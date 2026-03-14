{ ... }:
{
  home.username = "cdmwebs";
  home.homeDirectory = "/Users/cdmwebs";

  home.sessionVariables = {
    SSH_AUTH_SOCK = "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
  };

  programs = {
    git.settings.gpg.ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
    zsh.shellAliases.switch = "darwin-rebuild switch --flake ~/.config/nix#speediest";
  };
}
