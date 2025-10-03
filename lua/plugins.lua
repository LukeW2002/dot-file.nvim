return {
  -- ╭────────────────────────╮
  -- │  Plugin manager itself │
  -- ╰────────────────────────╯
  {
    'folke/lazy.nvim',               -- replaces packer.nvim
    version = '*',                   -- always latest tag
  },
{ 'junegunn/fzf' },       -- native binary (C)
{ 'junegunn/fzf.vim' },   -- Vim interface

  -- ╭────────────────────────╮
  -- │       Themes / UI      │
  -- ╰────────────────────────╯
  {
  'folke/tokyonight.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('tokyonight').setup({
      style = 'night', -- storm, moon, night, day
      transparent = false,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        sidebars = 'dark',
        floats = 'dark',
      },
    })
  end,
},

  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
      require('catppuccin').setup({
        flavour = 'mocha', -- latte, frappe, macchiato, mocha
        background = {
          light = 'latte',
          dark = 'mocha',
        },
        transparent_background = false,
        show_end_of_buffer = false,
        term_colors = false,
        dim_inactive = {
          enabled = false,
          shade = 'dark',
          percentage = 0.15,
        },
        no_italic = false,
        no_bold = false,
        no_underline = false,
        styles = {
          comments = { 'italic' },
          conditionals = { 'italic' },
          loops = {},
          functions = {},
          keywords = {},
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
          operators = {},
        },
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          telescope = true,
          notify = false,
          mini = false,
        },
      })
    end,
  },
  
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    config = function()
      require('rose-pine').setup({
        variant = 'auto', -- auto, main, moon, or dawn
        dark_variant = 'main',
        bold_vert_split = false,
        dim_nc_background = false,
        disable_background = false,
        disable_float_background = false,
        disable_italics = false,
        groups = {
          background = 'base',
          background_nc = '_experimental_nc',
          panel = 'surface',
          panel_nc = 'base',
          border = 'highlight_med',
          comment = 'muted',
          link = 'iris',
          punctuation = 'subtle',
          error = 'love',
          hint = 'iris',
          info = 'foam',
          warn = 'gold',
          headings = {
            h1 = 'iris',
            h2 = 'foam',
            h3 = 'rose',
            h4 = 'gold',
            h5 = 'pine',
            h6 = 'foam',
          }
        },
        highlight_groups = {
          ColorColumn = { bg = 'rose' },
          CursorLine = { bg = 'foam', blend = 10 },
          StatusLine = { fg = 'love', bg = 'love', blend = 10 },
        }
      })
    end,
  },
  
  {
    'rebelot/kanagawa.nvim',
    config = function()
      require('kanagawa').setup({
        compile = false,
        undercurl = true,
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = true},
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = false,
        dimInactive = false,
        terminalColors = true,
        colors = {
          palette = {},
          theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
        },
        overrides = function(colors)
          return {}
        end,
        theme = "wave",
        background = {
          dark = "wave",
          light = "lotus"
        },
      })
    end,
  },
  
  {
    'EdenEast/nightfox.nvim',
    config = function()
      require('nightfox').setup({
        options = {
          compile_path = vim.fn.stdpath("cache") .. "/nightfox",
          compile_file_suffix = "_compiled",
          transparent = false,
          terminal_colors = true,
          dim_inactive = false,
          module_default = true,
          colorblind = {
            enable = false,
            simulate_only = false,
            severity = {
              protan = 0,
              deutan = 0,
              tritan = 0,
            },
          },
          styles = {
            comments = "italic",
            conditionals = "NONE",
            constants = "NONE",
            functions = "NONE",
            keywords = "NONE",
            numbers = "NONE",
            operators = "NONE",
            strings = "NONE",
            types = "NONE",
            variables = "NONE",
          },
          inverse = {
            match_paren = false,
            visual = false,
            search = false,
          },
        },
        palettes = {},
        specs = {},
        groups = {},
      })
    end,
  },
  
  -- Cyberpunk vibes
  {
    'Mofiqul/dracula.nvim',
    config = function()
      require('dracula').setup({
        colors = {},
        show_end_of_buffer = true,
        transparent_bg = false,
        lualine_bg_color = nil,
        italic_comment = true,
      })
    end,
  },

  { 'ayu-theme/ayu-vim' },
  { 'sickill/vim-monokai' },
  { 'ellisonleao/gruvbox.nvim' },
  { 'dylanaraps/wal.vim' },
  {
  'MunifTanjim/prettier.nvim',
  cmd = { 'Prettier', 'PrettierAsync' }, -- lazy-load on demand
  config = function()
    require('prettier').setup({})
  end,
},

  { 'sainnhe/everforest' },
  { 
    'junegunn/goyo.vim',
    config = function()
      vim.g.goyo_width = 120
      vim.g.goyo_height = '90%'
      vim.g.goyo_linenr = 0
    end,
  },
  { 'folke/trouble.nvim' },

  -- ╭────────────────────────╮
  -- │     Treesitter & text  │
  -- ╰────────────────────────╯
  {
    'nvim-treesitter/nvim-treesitter',
    build        = ':TSUpdate',      -- keep parsers up‑to‑date automatically
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = { 
          "lua", "rust", "toml", 
          "gdscript", "markdown", "markdown_inline"
        },
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
        rainbow = {
          enable = true,
          extended_mode = true,
          max_file_lines = nil,
        }
      }
    end,
    dependencies = {
      'windwp/nvim-ts-autotag',
      'HiPhish/rainbow-delimiters.nvim',
    },
  },
  { 'sheerun/vim-polyglot' },
  {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup({
      close_if_last_window = false,
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,
      window = {
        position = "left",
        width = 30,
        mapping_options = {
          noremap = true,
          nowait = true,
        },
        mappings = {
          ["<space>"] = "none",
          ["<2-LeftMouse>"] = "open",
          ["<cr>"] = "open",
          ["<esc>"] = "revert_preview",
          ["P"] = { "toggle_preview", config = { use_float = true } },
          ["S"] = "open_split",
          ["s"] = "open_vsplit",
          ["t"] = "open_tabnew",
          ["w"] = "open_with_window_picker",
          ["C"] = "close_node",
          ["z"] = "close_all_nodes",
          ["a"] = { 
            "add",
            config = {
              show_path = "none" -- "none", "relative", "absolute"
            }
          },
          ["A"] = "add_directory",
          ["d"] = "delete",
          ["r"] = "rename",
          ["y"] = "copy_to_clipboard",
          ["x"] = "cut_to_clipboard",
          ["p"] = "paste_from_clipboard",
          ["c"] = "copy", -- takes text input for destination
          ["m"] = "move", -- takes text input for destination
          ["q"] = "close_window",
          ["R"] = "refresh",
          ["?"] = "show_help",
          ["<"] = "prev_source",
          [">"] = "next_source",
        }
      },
      filesystem = {
        filtered_items = {
          visible = false,
          hide_dotfiles = true,
          hide_gitignored = true,
          hide_hidden = true,
          hide_by_name = {
            "node_modules"
          },
          hide_by_pattern = {
            "*.meta",
            "*/src/*/tsconfig.json",
          },
          always_show = {
            ".gitignored",
          },
          never_show = {
            ".DS_Store",
            "thumbs.db"
          },
        },
        follow_current_file = {
          enabled = false,
          leave_dirs_open = false,
        },
        group_empty_dirs = false,
        hijack_netrw_behavior = "open_default",
        use_libuv_file_watcher = false,
      },
      buffers = {
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },
        group_empty_dirs = true,
        show_unloaded = true,
      },
      git_status = {
        window = {
          position = "float",
          mappings = {
            ["A"]  = "git_add_all",
            ["gu"] = "git_unstage_file",
            ["ga"] = "git_add_file",
            ["gr"] = "git_revert_file",
            ["gc"] = "git_commit",
            ["gp"] = "git_push",
            ["gg"] = "git_commit_and_push",
          }
        }
      }
    })
  end,
},

  -- ╭────────────────────────╮
  -- │    LSP & diagnostics   │
  -- ╰────────────────────────╯
  --
  --
  { 'habamax/vim-godot' },
  { 'neovim/nvim-lspconfig' },
  {
    'nvimdev/lspsaga.nvim',
    dependencies = 'neovim/nvim-lspconfig',
    config = function()
      require('lspsaga').setup({})
    end,
  },
  { 'williamboman/mason.nvim' },
  { 'williamboman/mason-lspconfig.nvim' },
  { 'MunifTanjim/eslint.nvim' },
  { 'jose-elias-alvarez/null-ls.nvim' },
  { 'simrat39/rust-tools.nvim' },     -- (deduped)
  { 'OmniSharp/omnisharp-vim' },

  -- ╭────────────────────────╮
  -- │ Completion / snippets  │
  -- ╰────────────────────────╯
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'saadparwaiz1/cmp_luasnip',
      'L3MON4D3/LuaSnip',
      'honza/vim-snippets',
    },
  },
  { 'prabirshrestha/asyncomplete.vim' },
  { 'prabirshrestha/asyncomplete-lsp.vim' },
  { 'ervandew/supertab' },
  { 'SirVer/ultisnips' },
  --{
  --'quangnguyen30192/cmp-nvim-ultisnips',
  --requires = { 'SirVer/ultisnips' },
  --},



  -- ╭────────────────────────╮
  -- │Fuzzy finders / pickers │
  -- ╰────────────────────────╯
  {
    'nvim-telescope/telescope.nvim',
    version      = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
  { 'junegunn/fzf.vim' },
  { 'nvim-telescope/telescope-dap.nvim' },
  { 'junegunn/vim-github-dashboard' },

  -- ╭────────────────────────╮
  -- │         DAP            │
  -- ╰────────────────────────╯
  { 'mfussenegger/nvim-dap' },
  { 'rcarriga/nvim-dap-ui',        dependencies = 'mfussenegger/nvim-dap' },
  { 'theHamsta/nvim-dap-virtual-text', dependencies = 'mfussenegger/nvim-dap' },
  { 'nvim-neotest/nvim-nio' },

  -- ╭────────────────────────╮
  -- │        Utility         │
  -- ╰────────────────────────╯
  { 'xolox/vim-misc',     dependencies = { 'xolox/vim-misc' }},
  { 'xolox/vim-notes' },
  { 'vlime/vlime', rtp = 'vim/' },  -- use the Vim runtime subdir
  { 'lervag/vimtex' },
  { 'KeitaNakamura/tex-conceal.vim' },
  { 'lilydjwg/colorizer' },
  { 'norcalli/nvim-colorizer.lua' },
  
  -- ╭────────────────────────╮
  -- │      Markdown          │
  -- ╰────────────────────────╯
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    build = function() vim.fn["mkdp#util#install"]() end,
    init = function()
      vim.g.mkdp_filetypes = { 'markdown' }
    end,
    ft = { 'markdown' },
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' },
    opts = {},
  },
}

