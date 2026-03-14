# Nix Config

This repo currently manages:

- one macOS host, `speediest`, with `nix-darwin`
- one Linux user profile, `cdmwebs`, with standalone Home Manager

The repo uses:

- `nix-darwin` for system settings and activation
- `home-manager` for user-level programs and dotfiles
- `nix-homebrew` to keep Homebrew under declarative control

The current targets are Apple Silicon macOS (`aarch64-darwin`) and a Linux Home Manager profile (`x86_64-linux`) for user `cdmwebs`.

## What Lives Where

- [flake.nix](./flake.nix): flake inputs, the `speediest` macOS host, and the `cdmwebs` Linux Home Manager profile
- [darwin.nix](./darwin.nix): system-level macOS composition
- [modules/darwin/](./modules/darwin): macOS-only system modules
- [home.nix](./home.nix): shared Home Manager defaults for macOS and Linux
- [home/darwin.nix](./home/darwin.nix): macOS-only Home Manager settings
- [home/linux.nix](./home/linux.nix): Linux-only Home Manager settings
- [home/git.nix](./home/git.nix): Git config and signing
- [home/tmux.nix](./home/tmux.nix): tmux config
- [home/zsh.nix](./home/zsh.nix): Zsh config
- [nvim/](./nvim): repo-managed LazyVim config

Package-management split:

- Nix/Home Manager: CLI tools, shell config, terminal tools, fonts, Neovim binary, and the checked-in `nvim/` config
- Homebrew: GUI apps, Mac App Store installs, and a few toolchain dependencies expected under `/opt/homebrew`

## macOS Setup

The macOS host setup assumes:

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

Apply the macOS flake for the first time:

```zsh
nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake ~/.config/nix#speediest
```

After the first successful switch, use:

```zsh
darwin-rebuild switch --flake ~/.config/nix#speediest
```

## Linux Setup

The Linux Home Manager profile assumes:

- the checkout lives at `~/.config/nix`
- the user is `cdmwebs`
- the target uses `x86_64-linux`

Clone the repo first:

```zsh
git clone git@github.com:cdmwebs/nix-config.git ~/.config/nix
cd ~/.config/nix
```

On Debian, install Nix first if it is not already present:

```zsh
sh <(curl -L https://nixos.org/nix/install)
```

Then load Nix into the current shell without logging out:

```zsh
. ~/.nix-profile/etc/profile.d/nix.sh
```

Make sure flakes are enabled. Create `~/.config/nix/nix.conf` if it does not exist, then add:

```text
experimental-features = nix-command flakes
```

or pass `--extra-experimental-features "nix-command flakes"` on the command line while bootstrapping. `nix.conf` is gitignored in this repo, so it can live in the checkout without showing up as a local change.

For a first-time standalone Home Manager bootstrap on Debian, use:

```zsh
nix run github:nix-community/home-manager -- switch --flake ~/.config/nix#cdmwebs
```

After that first activation, the `home-manager` command will be installed and you can use:

```zsh
home-manager switch --flake ~/.config/nix#cdmwebs
```

## Setup Notes

- The first rebuild can take a while. It may install Homebrew formulae, casks, and Mac App Store apps.
- Mac App Store installs require being signed into the App Store first.
- Some steps will prompt for `sudo`.
- `Ghostty` is installed via Homebrew cask.
- Home Manager is wired into the same `darwin-rebuild switch`, so there is no separate `home-manager switch` flow here.
- On Debian/Linux, Home Manager runs standalone, so `home-manager switch --flake` is the normal apply path.

## Daily Use

After editing the macOS config, apply changes with:

```zsh
darwin-rebuild switch --flake ~/.config/nix#speediest
```

There is also a shell alias in [home/zsh.nix](./home/zsh.nix) for this:

```zsh
switch
```

On Linux, the same alias maps to:

```zsh
home-manager switch --flake ~/.config/nix#cdmwebs
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

For Linux-only changes, swap the last command for:

```zsh
home-manager switch --flake ~/.config/nix#cdmwebs
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
