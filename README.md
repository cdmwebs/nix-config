### Getting Started

Check for system software updates: Settings > General > Software Updates.

```zsh
xcode-select --install
git clone git@github.com:cdmwebs/nix-config.git ~/.config/nix
```

1. Install nix:

```zsh
sh <(curl -L https://nixos.org/nix/install)
```

1. Build nix config:

```zsh
darwin-rebuild switch --flake ~/.config/nix#speediest
```

** Update Flake **

```zsh
nix flake update
```
