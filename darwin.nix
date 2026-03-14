{ ... }:
{
  imports = [
    ./modules/darwin/host.nix
    ./modules/darwin/packages.nix
    ./modules/darwin/homebrew.nix
    ./modules/darwin/applications.nix
    ./modules/darwin/defaults.nix
    ./modules/darwin/nix.nix
  ];
}
