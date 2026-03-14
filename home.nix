{ config, pkgs, ... }:

{
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    coreutils
    doctl
    fd
    nixd
    nixfmt-rfc-style
    powerline
    ripgrep
    rsync
    stylua
    tree
    tmux-mem-cpu-load
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = { };

  xdg = {
    enable = true;
    configFile."nvim".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/nvim";
  };

  home.sessionVariables = {
    VISUAL = "nvim";
    EDITOR = "nvim";
    SSH_AUTH_SOCK = "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
  };

  # Rebind detach keys so ctrl-p works for history.
  # home.file."./.docker/config.json".text = ''
  #   {
  #   	"auths": {
  #   		"https://index.docker.io/v1/": {},
  #   		"https://index.docker.io/v1/access-token": {},
  #   		"https://index.docker.io/v1/refresh-token": {},
  #   		"registry.digitalocean.com": {}
  #   	},
  #   	"credsStore": "osxkeychain",
  #   	"currentContext": "orbstack",
  #   	"detachKeys": "ctrl-\\"
  #   }
  # '';

  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };

    mise = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
