{ pkgs, config, ... }: {
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [ pkgs.alacritty pkgs.mkalias pkgs.neovim pkgs.tmux ];

  fonts.packages =
    [ (pkgs.nerdfonts.override { fonts = [ "RobotoMono" "SourceCodePro" ]; }) ];

  homebrew = {
    enable = true;

    brews = [
      "autoconf"
      "coreutils"
      "gcc"
      "git"
      "gmp"
      "libyaml"
      "mise"
      "openssl@3"
      "readline"
      "ripgrep"
      "rsync"
    ];

    casks = [
      "1password"
      "1password-cli"
      "alfred"
      "discord"
      "firefox"
      "fork"
      "google-chrome"
      "meetingbar"
      "ngrok"
      "orbstack"
      "pop"
      "slack"
      "tableplus"
      "vlc"
    ];
  };

  system.activationScripts.applications.text = let
    env = pkgs.buildEnv {
      name = "system-applications";
      paths = config.environment.systemPackages;
      pathsToLink = "/Applications";
    };
  in pkgs.lib.mkForce ''
    # Set up applications
    		echo "setting up /Applications..." >&2
    		rm -rf /Applications/Nix\ Apps
    		mkdir -p /Applications/Nix\ Apps
    		find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
    		while read -r src; do
    			app_name=$(basename "$src")
    				echo "copying $src" >&2
    				${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
    				done
    				'';

  system = {
    keyboard.enableKeyMapping = true;
    keyboard.remapCapsLockToControl = true;

    # Set Git commit hash for darwin-version.
    # configurationRevision = self.rev or self.dirtyRev or null;

    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 5;

    defaults = {
      dock.autohide = true;
      dock.tilesize = 18;
      dock.persistent-others =
        [ "/Users/cdmwebs/Desktop" "/Users/cdmwebs/Downloads" ];
      finder.FXPreferredViewStyle = "clmv";
      finder.ShowPathbar = true;
      finder.ShowStatusBar = true;

      loginwindow.GuestEnabled = false;

      NSGlobalDomain.KeyRepeat = 2;
      NSGlobalDomain."com.apple.mouse.tapBehavior" = 1;
      NSGlobalDomain.NSTableViewDefaultSizeMode = 1;

      SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;

      trackpad.Clicking = true;
    };
  };

  security.pam.enableSudoTouchIdAuth = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  nix = {
    package = pkgs.nix;
    gc.automatic = true;
    optimise.automatic = true;
    settings = {
      experimental-features =
        [ "nix-command" "flakes" ]; # Necessary for using flakes on this system.
    };
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  users.users.cdmwebs = {
    name = "cdmwebs";
    home = "/Users/cdmwebs";
  };
}
