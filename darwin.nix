{ pkgs, config, ... }:
{
  nixpkgs.config.allowUnfree = true;

  system.primaryUser = "cdmwebs";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
    # Keep GUI apps here so the activation script can link them into /Applications.
    pkgs.alacritty
    pkgs.mkalias
  ];

  fonts.packages = [
    pkgs.nerd-fonts.roboto-mono
    pkgs.nerd-fonts.sauce-code-pro
  ];

  homebrew = {
    enable = true;

    # Keep Homebrew focused on GUI apps, App Store installs, and toolchain
    # dependencies that non-Nix tooling often expects under /opt/homebrew.
    brews = [
      "autoconf"
      "gcc"
      "gmp"
      "libyaml"
      "mas"
      "openssl@3"
      "readline"
    ];

    casks = [
      "1password"
      "1password-cli"
      "alfred"
      "discord"
      "expressvpn"
      "firefox"
      "fork"
      "fujitsu-scansnap-home"
      "ghostty"
      "google-chrome"
      "meetingbar"
      "ngrok"
      "orbstack"
      "pop"
      "slack"
      "tableplus"
      "vlc"
    ];

    masApps = {
      "Flighty – Live Flight Tracker" = 1358823008;
      "RadarScope" = 288419283;
      "Xcode" = 497799835;
    };
  };

  system.activationScripts.applications.text =
    let
      env = pkgs.buildEnv {
        name = "system-applications";
        paths = config.environment.systemPackages;
        pathsToLink = [ "/Applications" ];
      };
    in
    pkgs.lib.mkForce ''
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
      dock.persistent-others = [
        {
          folder = {
            path = "/Users/cdmwebs/Desktop";
            displayas = "folder";
            arrangement = "date-added";
            showas = "grid";
          };
        }
        {
          folder = {
            path = "/Users/cdmwebs/Downloads";
            arrangement = "date-added";
            displayas = "folder";
            showas = "grid";
          };
        }
      ];
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

  security.pam.services.sudo_local.touchIdAuth = true;

  nix = {
    package = pkgs.nix;
    gc.automatic = true;
    optimise.automatic = true;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ]; # Necessary for using flakes on this system.
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
