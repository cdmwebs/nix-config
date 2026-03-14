{
  description = "cdmwebs darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
      inputs.brew-src.url = "github:Homebrew/brew/5.0.2";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nix-darwin,
      nix-homebrew,
      home-manager,
      nixpkgs,
    }:
    {
      darwinConfigurations = {
        speediest = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            ./darwin.nix
            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                enable = true;
                enableRosetta = true;
                user = "cdmwebs";
                autoMigrate = true;
              };
            }
            home-manager.darwinModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                verbose = true;
                users.cdmwebs.imports = [
                  ./home.nix
                  ./home/alacritty.nix
                  ./home/git.nix
                  ./home/tmux.nix
                  ./home/zsh.nix
                ];
              };
            }
          ];
        };

      };
      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations.speediest.pkgs;
    };
}
