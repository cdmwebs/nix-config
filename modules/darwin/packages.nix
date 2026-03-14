{ pkgs, ... }:
{
  # Keep GUI apps here so the activation script can copy them into /Applications.
  environment.systemPackages = [
    pkgs.alacritty
  ];

  fonts.packages = [
    pkgs.nerd-fonts.roboto-mono
    pkgs.nerd-fonts.sauce-code-pro
  ];
}
