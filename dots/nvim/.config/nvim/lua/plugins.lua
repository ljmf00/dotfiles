return {
  -- lazy nvim plugin
  {
    dir = '~/dotfiles/dist/3rdparty/nvim/lazy.nvim',
    lazy = false,
    priority = 1000,
  },

  -- theme
  {
    dir = '~/dotfiles/dist/3rdparty/vim/sonokai',
    lazy = false,
    priority = 999,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      'yamatsum/nvim-nonicons',
      'itchyny/lightline.vim',
    },
    config = function()
      vim.cmd 'silent! source ~/.config/nvim/lua/plugconf/sonokai.vim'
    end,
  },

  -- alternative light theme
  'folke/tokyonight.nvim',

  -- icons
  { "nvim-tree/nvim-web-devicons" },
  { 'yamatsum/nvim-nonicons' },

  -- buffer line
  {
    'romgrk/barbar.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'yamatsum/nvim-nonicons',
      'lewis6991/gitsigns.nvim',
    },
    init = function() vim.g.barbar_auto_setup = false end,
    opts = {},
  },

  -- light line
  {
    'itchyny/lightline.vim',
    lazy = false,
    init = function()
      require "plugconf/lightline"
    end,
  },

  -- Tagbar
  {
    'preservim/tagbar',
    cmd = "TagbarToggle",
    tag = 'v3.0.0',
    init = function()
      require "plugconf/tagbar"
    end,
  },

  -- Floating terminal
  {
    'voldikss/vim-floaterm',
    cmd = "FloatermToggle",
    init = function()
      require "plugconf/floaterm"
    end,
  },

  -- extra theme dressing
  "stevearc/dressing.nvim",

  -- wakatime
  { dir = '~/dotfiles/dist/3rdparty/vim/wakatime' },

  -- move lines around
  {
    dir = '~/dotfiles/dist/3rdparty/vim/schlepp',
    init = function()
      vim.cmd 'silent! source ~/.config/nvim/lua/plugconf/schlepp.vim'
    end,
  },

  -- surround fast change
  {
    dir = '~/dotfiles/dist/3rdparty/vim/surround',
    event = "InsertEnter",
  },
  -- auto indentation
  {
    dir = '~/dotfiles/dist/3rdparty/vim/sleuth',
    event = "BufRead",
  },

  -- text colorizer
  "NvChad/nvim-colorizer.lua",

  -- comments
  "numToStr/Comment.nvim",

  -- Indent guidelines
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require('plugconf/indentblank')
    end,
  },

  --  Highlight similar words
  { 'RRethy/vim-illuminate', commit = 'fb83d835eac50baeef49aac20c524a80727db0ac' },

  -- which keys popup plugin
  {
    'folke/which-key.nvim',
    event = "VeryLazy",
    opts = {},
  },

  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    opts = function()
      return require "plugconf/nvimtree"
    end,
    config = function(_, opts)
      require("nvim-tree").setup(opts)
      vim.g.nvimtree_side = opts.view.side
    end,
  },

  -- Autopairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = function()
      return require('plugconf/autopairs')
    end,
  },

  {
    'neomake/neomake',
    config = function()
      require('plugconf/neomake')
    end,
  },

  -- Git Support
  { 'tpope/vim-fugitive', tag = 'v3.4' },

  {
    'lewis6991/gitsigns.nvim',
    ft = { "gitcommit", "diff" },
    tag = 'v0.5',
    requires = {
      'nvim-lua/plenary.nvim'
    },
    init = function()
      -- load gitsigns only when a git file is opened
      vim.api.nvim_create_autocmd({ "BufRead" }, {
        group = vim.api.nvim_create_augroup("GitSignsLazyLoad", { clear = true }),
        callback = function()
          vim.fn.system("git -C " .. '"' .. vim.fn.expand "%:p:h" .. '"' .. " rev-parse")
          if vim.v.shell_error == 0 then
            vim.api.nvim_del_augroup_by_name "GitSignsLazyLoad"
            vim.schedule(function()
              require("lazy").load { plugins = { "gitsigns.nvim" } }
            end)
          end
        end,
      })
    end,
    opts = function()
      return require('plugconf/gitsigns')
    end,
  },

  -- LSP Support
  {
    'neovim/nvim-lspconfig',
    event = "BufRead",
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      require('plugconf/lsp')
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
    },
    cmd = { "LspInstall", "LspUninstall" },
    lazy = true,
  },

  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    build = ":MasonUpdate",
    opts = function()
      return require('plugconf/mason')
    end,
  },

  -- Lua snippet plugin
  {
    "L3MON4D3/LuaSnip",
    dependencies = "rafamadriz/friendly-snippets",
    config = function()
      require("plugconf/luasnip")
    end,
  },

  -- Autocomplete
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "windwp/nvim-autopairs",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
    },
    config = function()
      require('plugconf/cmp')
    end,
  },

  -- Treesitter
  {
    dir = '~/dotfiles/dist/3rdparty/vim/nvim-treesitter',
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    event = "BufRead",
    build = ":TSUpdate",
    opts = function()
      return require('plugconf/treesitter')
    end,
    config = function(_, opts)
      require("nvim-treesitter.install").prefer_git = false
      require'nvim-treesitter.configs'.setup(opts)
    end,
  },

  -- telescope fuzzy finder
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.1',
    cmd = "Telescope",

    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-lua/popup.nvim',
      'BurntSushi/ripgrep',

      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      { 'nvim-telescope/telescope-media-files.nvim' },
    },

    config = function()
      require('plugconf/telescope')
    end,
  },

  -- zettelkasten
  {
    'renerocksai/telekasten.nvim',
    dependencies = {'nvim-telescope/telescope.nvim'},
    config = function()
      require('telekasten').setup({
        home = vim.fn.expand("~/zettelkasten"),
      })
    end,
  },
}
