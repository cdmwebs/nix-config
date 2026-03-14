{
  system = {
    keyboard.enableKeyMapping = true;
    keyboard.remapCapsLockToControl = true;

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
}
