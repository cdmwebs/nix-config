{
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
      "pop-app"
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
}
