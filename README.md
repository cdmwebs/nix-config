# macOS Nix Config

This repo manages one macOS host, `speediest`, with:

- `nix-darwin` for system settings and activation
- `home-manager` for user-level programs and dotfiles
- `nix-homebrew` to keep Homebrew under declarative control

The current target is Apple Silicon macOS (`aarch64-darwin`) for user `cdmwebs`.

## What Lives Where

- [flake.nix](./flake.nix): flake inputs and the `speediest` host definition
- [darwin.nix](./darwin.nix): system-level macOS, Nix, fonts, Homebrew, and `/Applications/Nix Apps`
- [home.nix](./home.nix): user-level CLI packages and Home Manager defaults
- [home/alacritty.nix](./home/alacritty.nix): Alacritty config
- [home/git.nix](./home/git.nix): Git config and signing
- [home/tmux.nix](./home/tmux.nix): tmux config
- [home/zsh.nix](./home/zsh.nix): Zsh config
- [nvim/](./nvim): repo-managed LazyVim config

Package-management split:

- Nix/Home Manager: CLI tools, shell config, terminal tools, fonts, Neovim binary, and the checked-in `nvim/` config
- Homebrew: GUI apps, Mac App Store installs, and a few toolchain dependencies expected under `/opt/homebrew`

## Initial Setup

This repo assumes:

- the checkout lives at `~/.config/nix`
- the machine is `aarch64-darwin`
- the primary user is `cdmwebs`

Install Apple command line tools first:

```zsh
xcode-select --install
```

Clone the repo:

```zsh
git clone git@github.com:cdmwebs/nix-config.git ~/.config/nix
cd ~/.config/nix
```

Install Nix:

```zsh
sh <(curl -L https://nixos.org/nix/install)
```

Install Homebrew once before the first rebuild. This config uses `nix-homebrew`, but the initial Homebrew installation still needs to exist first:

```zsh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Apply the flake for the first time:

```zsh
nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake ~/.config/nix#speediest
```

After the first successful switch, use:

```zsh
darwin-rebuild switch --flake ~/.config/nix#speediest
```

## Setup Notes

- The first rebuild can take a while. It may install Homebrew formulae, casks, and Mac App Store apps.
- Mac App Store installs require being signed into the App Store first.
- Some steps will prompt for `sudo`.
- `Alacritty` is installed via Nix and linked into `/Applications/Nix Apps`.
- Home Manager is wired into the same `darwin-rebuild switch`, so there is no separate `home-manager switch` flow here.

## Daily Use

After editing the config, apply changes with:

```zsh
darwin-rebuild switch --flake ~/.config/nix#speediest
```

There is also a shell alias in [home/zsh.nix](./home/zsh.nix) for this:

```zsh
switch
```

If you just want to validate evaluation before switching:

```zsh
nix flake check --no-build
```

## Updating

Update all flake inputs:

```zsh
nix flake update
```

Update a single flake input:

```zsh
nix flake lock --update-input nixpkgs
```

Then review and apply:

```zsh
git diff flake.lock
nix flake check --no-build
darwin-rebuild switch --flake ~/.config/nix#speediest
```

## Neovim

Neovim is installed through Home Manager, but the actual editor config now lives in [nvim/](./nvim) and is managed as a normal LazyVim setup.

What that means in practice:

- Nix installs Neovim and supporting CLI tools like `fd`, `ripgrep`, `nixd`, `nixfmt`, and `stylua`
- Home Manager links `~/.config/nvim` to this repo's [nvim/](./nvim) directory using an out-of-store symlink
- `lazy.nvim` bootstraps itself on first launch
- LazyVim manages plugins inside Neovim instead of this repo trying to declare every plugin in Nix
- `:Lazy` can write files like `lazy-lock.json` because the config path is now writable

If `~/.config/nvim` already exists as a real directory, move it out of the way before switching so Home Manager can create the managed link:

```zsh
mv ~/.config/nvim ~/.config/nvim.pre-lazyvim
darwin-rebuild switch --flake ~/.config/nix#speediest
```

## Notes

- `nixpkgs` tracks `nixpkgs-unstable`, so updates can be broad.
- `darwin-rebuild switch` will warn if the git tree is dirty. That is expected when testing local changes.
