{
  system.primaryUser = "cdmwebs";

  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = "aarch64-darwin";
  };

  users.users.cdmwebs = {
    name = "cdmwebs";
    home = "/Users/cdmwebs";
  };
}
