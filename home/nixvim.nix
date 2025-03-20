{ ... }: {
  programs = {
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
          settings = {
            suggestion = {
              enabled = true;
              auto_trigger = true;
            };
          };
        };

        # cmp = {
        #   enable = false;
        #   settings = {
        #     experimental = { ghost_text = true; };
        #     sources = [{ name = "copilot"; }];
        #   };
        # };

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
              "terraform"
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
              bash = [ "shfmt" ];
              elixir = [ "elixirls" ];
              html = {
                __unkeyed-1 = "prettierd";
                __unkeyed-2 = "prettier";
                stop_after_fist = true;
              };
              javascript = {
                __unkeyed-1 = "prettierd";
                __unkeyed-2 = "prettier";
                stop_after_fist = true;
              };
              json = {
                __unkeyed-1 = "prettierd";
                __unkeyed-2 = "prettier";
                stop_after_fist = true;
              };
              lua = [ "stylua" ];
              nix = [ "nixd" ];
              python = [ "black" ];
              terraform = [ "tofu_fmt" ];
              typescript = [ "prettierd" ];
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
          settings.progress = {
            suppress_on_insert = true;
            ignore_done_already = true;
            poll_rate = 1;
          };
        };
      }; # /plugins
    };
  };
}
