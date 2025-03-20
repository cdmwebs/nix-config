{ pkgs, ... }: {
  programs = {

    tmux = {
      enable = true;
      mouse = true;
      sensibleOnTop = false;
      escapeTime = 0;
      terminal = "screen-256color";
      plugins = with pkgs; [
        tmuxPlugins.better-mouse-mode
        tmuxPlugins.vim-tmux-navigator
        tmuxPlugins.continuum
        tmuxPlugins.resurrect
        tmuxPlugins.gruvbox
      ];
      # plugins = [{
      #   plugin = pkgs.tmuxPlugins.mkTmuxPlugin {
      #     pluginName = "tmux-tokyo-night";
      #     rtpFilePath = "tmux-tokyo-night.tmux";
      #     version = "master";
      #     src = pkgs.fetchFromGitHub {
      #       owner = "fabioluciano";
      #       repo = "tmux-tokyo-night";
      #       rev = "156a5a010928ebae45f0d26c3af172e0425fdda8";
      #       sha256 = "sha256-tANO0EyXiplXPitLrwfyOEliHUZkCzDJ6nRjEVps180=";
      #     };
      #   };
      #   extraConfig = ''
      #     set -g @theme_variation 'moon'
      #     set -g @theme_enable_icons 1
      #     set -g @theme_left_separator ''
      #     set -g @theme_right_separator ''
      #   '';
      # }];
    };

  };
}
