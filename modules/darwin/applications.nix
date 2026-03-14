{ pkgs, config, ... }:
{
  system.activationScripts.applications.text =
    let
      env = pkgs.buildEnv {
        name = "system-applications";
        paths = config.environment.systemPackages;
        pathsToLink = [ "/Applications" ];
      };
    in
    pkgs.lib.mkForce ''
      # Copy real app bundles into /Applications so Finder and Spotlight can see them.
      echo "setting up /Applications..." >&2
      rm -rf /Applications/Nix\ Apps
      mkdir -p /Applications/Nix\ Apps
      ${pkgs.rsync}/bin/rsync -aL --delete ${env}/Applications/ /Applications/Nix\ Apps
    '';
}
