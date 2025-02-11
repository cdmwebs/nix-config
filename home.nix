{ pkgs, ... }:

{
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [ tmux powerline tmux-mem-cpu-load ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = { };

  home.sessionVariables = {
    VISUAL = "nvim";
    EDITOR = "nvim";
  };


  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;

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

    tmux = {
      enable = true;
      mouse = true;
      sensibleOnTop = false;
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

    git = {
      enable = true;
      userName = "Chris Moore";
      userEmail = "chris@cdmwebs.com";
      aliases = {
        co = "checkout";
        br = "branch";
        st = "status";
        cp = "cherry-pick";
      };
      ignores = [ ".DS_Store" ".irb_history" ];
      signing = {
        key =
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC4Ma9yQKOx8Rz4d08ejiqejRYhR5aVGyGfBloBTmOeR";
        signByDefault = true;
      };
      extraConfig = {
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        pull.rebase = true;
        diff.colorMoved = "default";
        push.default = "simple";

        # Sign using SSH keys via 1Password. Less trouble than gpg.
        gpg = {
          format = "ssh";
          ssh.program =
            "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
        };
      };
    };

    mise = {
      enable = true;
      enableZshIntegration = true;
    };

    zsh = {
      enable = true;
      autosuggestion = { enable = true; };
      enableCompletion = true;
      syntaxHighlighting.enable = true;

      sessionVariables = {
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "underline";
        ZSHZ_CASE = "smart";
      };

      initExtraBeforeCompInit = ''
        export CLICOLOR=1
      '';

      initExtra = ''
        list_ssh_fingerprints() {
          for key in ~/.ssh/*.pub; do
            if [[ -f "$key" ]]; then
              fingerprint=$(ssh-keygen -lf "$key")
              echo "$fingerprint ($key)"
            else
              echo "No public keys found in ~/.ssh."
              return 1
            fi
          done
        }
      '';

      shellAliases = {
        l = "ls -lh";
        ll = "ls -lah";
        switch = "darwin-rebuild switch --flake ~/.config/nix#speediest";
        gst = "git status";
        dcu = "mise exec nodejs@20.17 -- devcontainer up --workspace-folder ./";
        dcr =
          "mise exec nodejs@20.17 -- devcontainer up --workspace-folder ./ --remove-existing-container";
        dce =
          "mise exec nodejs@20.17 -- devcontainer exec --workspace-folder ./";
      };

      zplug = {
        enable = true;
        plugins = [
          { name = "agkozak/zsh-z"; }
          { name = "zdharma/fast-syntax-highlighting"; }
          { name = "zsh-users/zsh-completions"; }
          { name = "zsh-users/zsh-autosuggestions"; }
          {
            name = "romkatv/powerlevel10k";
            tags = [ "depth:1" ];
          }
        ];
      };
    };

    nixvim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;

      globals = {
        # Set <space> as the leader key
        mapleader = " ";
        have_nerd_font = true;
      };

      opts = {
        number = true;
        relativenumber = true;
        mouse = "a";
        showmode = false;

        breakindent = true;
        undofile = true;
        ignorecase = true;
        smartcase = true;
        signcolumn = "yes";
        updatetime = 250;
        timeoutlen = 500;

        splitright = true;
        splitbelow = true;

        inccommand = "split";

        cursorline = true;
        scrolloff = 10;

        hlsearch = true;

        # Sets how neovim will display certain whitespace characters in the editor.
        #  See `:help 'list'`
        #  and `:help 'listchars'`
        # list = true
        # listchars = { tab = "» ", trail = "·", nbsp = "␣" };
      };

      keymaps = [
        {
          mode = "n";
          key = "<Esc>";
          action = "<cmd>nohlsearch<CR>";
          options.desc = "Clear highlights";
        }
        {
          mode = "n";
          key = "[d";
          action = "diagnostics.goto_prev";
          options.desc = "Go to previous [D]iagnostic message";
        }
        {
          mode = "n";
          key = "]d";
          action = "diagnostics.goto_next";
          options.desc = "Go to next [D]iagnostic message";
        }
        {
          mode = "n";
          key = "<leader>e";
          action = "diagnostics.open_float";
          options.desc = "Show diagnostic [E]rror messages";
        }
        {
          mode = "n";
          key = "<leader>q";
          action = "<CMD>lua vim.diagnostic.setloclist()<CR>";
          options.desc = "Open diagnostic [Q]quickfix list";
        }
      ];

      colorschemes = {
        catppuccin.enable = false;
        gruvbox.enable = false;
        dracula.enable = false;

        tokyonight = {
          enable = true;
          settings.style = "moon";
        };
      };

      plugins = {
        lualine.enable = true;
        web-devicons.enable = true;

        copilot-lua = {
          enable = true;
          suggestion = {
            enabled = true;
            autoTrigger = true;
            keymap = { accept = "<Tab>"; };
          };
        };

        treesitter = {
          enable = true;
          settings = {
            auto_install = true;
            ensure_installed = [
              "bash"
              "c"
              "diff"
              "elixir"
              "html"
              "jsonc"
              "lua"
              "luadoc"
              "markdown"
              "vim"
              "vimdoc"
            ];
            highlight = {
              enable = true;
              additional_vim_regex_highlighting = [ "ruby" ];
            };
            indent = {
              enable = true;
              disable = [ "ruby" ];
            };
          };
        };

        telescope = {
          enable = true;

          keymaps = {
            # Find files using Telescope command-line sugar.
            "<leader>sf" = {
              action = "find_files";
              options.desc = "[S]earch [F]iles";
            };
            "<leader>sg" = {
              action = "live_grep";
              options.desc = "[S]earch by [G]rep";
            };
            "<leader>sh" = {
              action = "help_tags";
              options.desc = "[S]earch [H]elp";
            };
            "<leader>sk" = {
              action = "keymaps";
              options.desc = "[S]earch [K]eymaps";
            };
            "<leader>sw" = {
              action = "grep_string";
              options.desc = "[S]earch current [W]ord";
            };
            "<leader>sd" = {
              action = "diagnostics";
              options.desc = "[S]earch [D]iagnostics";
            };
            "<leader>sr" = {
              action = "resume";
              options.desc = "[S]earch [R]esume";
            };
            "<leader><leader>" = {
              action = "buffers";
              options.desc = "[ ] Search buffers";
            };

            "<C-p>" = {
              action = "git_files"; # FZF like bindings
              options.desc = "Just like the old days";
            };
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
          settings = {
            current_line_blame = true;
            current_line_blame_opts = {
              virt_text = true;
              virt_text_pos = "eol";
            };
            signs = {
              add = { text = "+"; };
              change = { text = "~"; };
              delete = { text = "_"; };
              topdelete = { text = "‾"; };
              changedelete = { text = "~"; };
            };
          };
        };

        which-key = { enable = true; };

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

        conform-nvim = {
          enable = true;
          settings = {
            format_on_save = {
              timeout_ms = 500;
              lsp_format = "fallback";
            };
            notify_on_error = false;
            formatters_by_ft = {
              lua = [ "stylua" ];
              nix = [ "nixd" ];
              bash = [ "shfmt" ];
              javascript = [ "prettierd" ];
              typescript = [ "prettierd" ];
              html = [ "prettierd" ];
              json = [ "prettierd" ];
              python = [ "isort" "black" ];
              elixir = [ "elixirls" ];
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
