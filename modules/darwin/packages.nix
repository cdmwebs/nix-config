{ pkgs, ... }:
{
  fonts.packages = [
    pkgs.nerd-fonts.roboto-mono
    pkgs.nerd-fonts.sauce-code-pro
  ];
}
