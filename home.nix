_:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/davish/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = { EDITOR = "nvim"; };

  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;

    git = {
      enable = true;
      userName = "Chris Moore";
      userEmail = "chris@cdmwebs.com";
      ignores = [ ".DS_Store" ];
      extraConfig = {
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
      };
    };

    zsh = {
      enable = true;
      shellAliases = {
        switch = "darwin-rebuild switch --flake ~/.config/nix#speediest";
      };
    };

    nixvim = {
      enable = true;
      defaultEditor = true;
      globals.mapleader = " ";

      viAlias = true;
      vimAlias = true;

      colorschemes.catppuccin.enable = true;

      plugins = {
        lualine.enable = true;
        web-devicons.enable = true;

        treesitter = { enable = true; };

        telescope = {
          enable = true;

          keymaps = {
            # Find files using Telescope command-line sugar.
            "<leader>ff" = "find_files";
            "<leader>fw" = "live_grep";
            "<leader>b" = "buffers";
            "<leader>fh" = "help_tags";
            "<leader>fd" = "diagnostics";
            # FZF like bindings
            "<C-p>" = "git_files";
            "<leader>p" = "oldfiles";
            "<C-f>" = "live_grep";
          };

          settings.defaults = {
            file_ignore_patterns = [
              "^.git/"
              "^.mypy_cache/"
              "^__pycache__/"
              "^output/"
              "^data/"
              "%.ipynb"
            ];
            set_env.COLORTERM = "truecolor";
          };
        };

        gitsigns = {
          enable = true;
          settings.current_line_blame = true;
        };

        which-key = {
          enable = false;
          registrations = {
            "<leader>fg" = "Find Git files with telescope";
            "<leader>fw" = "Find text with telescope";
            "<leader>ff" = "Find files with telescope";
          };
        };

        lsp = {
          enable = true;
          servers = {
            bashls.enable = true;
            elixirls.enable = true;
            nixd.enable = true;
          };
          keymaps = {
            lspBuf = {
              "gd" = "definition";
              "gD" = "references";
              "gt" = "type_definition";
              "gi" = "implementation";
              "K" = "hover";
              "<leader>r" = "rename";
              "<leader>f" = "format";
            };
          };
        };

        none-ls = {
          enable = true;
          sources = {
            diagnostics = { };
            formatting = {
              nixfmt.enable = true;
              markdownlint.enable = true;
              shellharden.enable = true;
              shfmt.enable = true;
            };
          };
        };

        fidget = {
          enable = true;
          logger = {
            level = "warn"; # “off”, “error”, “warn”, “info”, “debug”, “trace”
            floatPrecision =
              1.0e-2; # Limit the number of decimals displayed for floats
          };
          progress = {
            pollRate = 0; # How and when to poll for progress messages
            suppressOnInsert =
              true; # Suppress new messages while in insert mode
            ignoreDoneAlready =
              false; # Ignore new tasks that are already complete
            ignoreEmptyMessage =
              false; # Ignore new tasks that don't contain a message
            clearOnDetach =
              # Clear notification group when LSP server detaches
              ''
                function(client_id)
                  local client = vim.lsp.get_client_by_id(client_id)
                  return client and client.name or nil
                end
              '';
            notificationGroup =
              # How to get a progress message's notification group key
              ''
                function(msg) return msg.lsp_client.name end
              '';
            ignore = [ ]; # List of LSP servers to ignore
            lsp = {
              progressRingbufSize =
                0; # Configure the nvim's LSP progress ring buffer size
            };
            display = {
              renderLimit = 16; # How many LSP messages to show at once
              doneTtl = 3; # How long a message should persist after completion
              doneIcon =
                "✔"; # Icon shown when all LSP progress tasks are complete
              doneStyle = "Constant"; # Highlight group for completed LSP tasks
              progressTtl =
                "math.huge"; # How long a message should persist when in progress
              progressIcon = {
                pattern = "dots";
                period = 1;
              }; # Icon shown when LSP progress tasks are in progress
              progressStyle =
                "WarningMsg"; # Highlight group for in-progress LSP tasks
              groupStyle =
                "Title"; # Highlight group for group name (LSP server name)
              iconStyle = "Question"; # Highlight group for group icons
              priority = 30; # Ordering priority for LSP notification group
              skipHistory =
                true; # Whether progress notifications should be omitted from history
              formatMessage = ''
                require ("fidget.progress.display").default_format_message
              ''; # How to format a progress message
              formatAnnote = ''
                function (msg) return msg.title end
              ''; # How to format a progress annotation
              formatGroupName = ''
                function (group) return tostring (group) end
              ''; # How to format a progress notification group's name
              overrides = {
                rust_analyzer = { name = "rust-analyzer"; };
              }; # Override options from the default notification config
            };
          };
          notification = {
            pollRate = 10; # How frequently to update and render notifications
            filter = "info"; # “off”, “error”, “warn”, “info”, “debug”, “trace”
            historySize = 128; # Number of removed messages to retain in history
            overrideVimNotify = true;
            redirect = ''
              function(msg, level, opts)
                if opts and opts.on_open then
                  return require("fidget.integration.nvim-notify").delegate(msg, level, opts)
                end
              end
            '';
            configs = {
              default = "require('fidget.notification').default_config";
            };

            window = {
              normalHl = "Comment";
              winblend = 0;
              border = "none"; # none, single, double, rounded, solid, shadow
              zindex = 45;
              maxWidth = 0;
              maxHeight = 0;
              xPadding = 1;
              yPadding = 0;
              align = "bottom";
              relative = "editor";
            };
            view = {
              stackUpwards =
                true; # Display notification items from bottom to top
              iconSeparator = " "; # Separator between group name and icon
              groupSeparator = "---"; # Separator between notification groups
              groupSeparatorHl =
                # Highlight group used for group separator
                "Comment";
            };
          };
        };

      }; # /plugins
    };
  };
}
