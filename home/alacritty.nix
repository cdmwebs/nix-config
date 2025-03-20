{ ... }: {
  programs = {
    alacritty = {
      enable = true;
      settings = {
        env = { TERM = "xterm-256color"; };

        font = {
          size = 12;

          bold = {
            family = "SauceCodePro Nerd Font Mono";
            style = "Heavy";
          };

          bold_italic = {
            family = "SauceCodePro Nerd Font Mono";
            style = "Heavy Italic";
          };

          italic = {
            family = "SauceCodePro Nerd Font Mono";
            style = "Medium Italic";
          };

          normal = {
            family = "SauceCodePro Nerd Font Mono";
            style = "Medium";
          };
        };

        # TODO: figure out themes
        # general.import = [ pkgs.alacritty-theme.cyber_punk_neon ];

        scrolling = {
          history = 10000;
          multiplier = 6;
        };

        window = {
          blur = true;
          decorations = "Full";
          dynamic_title = true;
          dynamic_padding = true;
          opacity = 0.95;
          option_as_alt = "Both";
          padding = {
            x = 10;
            y = 10;
          };
        };

      };
    };
  };
}
