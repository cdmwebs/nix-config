{ ... }:
{
  home.username = "cdmwebs";
  home.homeDirectory = "/home/cdmwebs";

  targets.genericLinux.enable = true;

  programs.zsh.shellAliases.switch = "home-manager switch --flake ~/.config/nix#cdmwebs";
}
