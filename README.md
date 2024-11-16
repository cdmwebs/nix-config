1. Install nix:

```sh
sh <(curl -L https://nixos.org/nix/install)
```

2. Set up nix-darwin in home directory:

```sh
mkdir .config/nix
cd .config/nix
nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake ~/.config/nix#speediest
```

3. Build nix config:

```sh
darwin-rebuild switch --flake ~/.config/nix#speediest
```


** Update Flake **

```sh
nix flake update
```
