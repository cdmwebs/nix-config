{ pkgs, ... }:
{
  # Keep GUI apps here so the activation script can link them into /Applications.
  environment.systemPackages = [
    pkgs.alacritty
    pkgs.mkalias
  ];

  fonts.packages = [
    pkgs.nerd-fonts.roboto-mono
    pkgs.nerd-fonts.sauce-code-pro
  ];
}
