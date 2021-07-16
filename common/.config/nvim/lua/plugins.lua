local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end

return require('packer').startup(function()
  -- Packer
  use 'wbthomason/packer.nvim'

  -- Theme
  use {
    'sainnhe/sonokai',
    config = function()
      require 'pconfig.c-sonokai'
    end,
  }

  -- Misc settings

  --  Auto relative number toggle
  use 'jeffkreeftmeijer/vim-numbertoggle'
  --  File number on vim startup
  use 'bogado/file-line'
  --  Sensible default configs
  use 'tpope/vim-sensible'
  --  Surround fast change
  use 'tpope/vim-surround'
  --  Auto indentation
  use 'tpope/vim-sleuth'
  --  Session manager
  use 'tpope/vim-obsession'
  --  Color code highlighter
  use {
    'rrethy/vim-hexokinase',
    run = 'make hexokinase',
    config = function()
      require 'pconfig.c-hexokinase'
    end,
  }
  --  Highlight similar words
  use { 'RRethy/vim-illuminate' }
  -- Smooth scroll
  use {
      "karb94/neoscroll.nvim",
      event = "WinScrolled",
      config = function()
          require("neoscroll").setup()
      end
  }
  --  Custom dashboard
  use {
      "glepnir/dashboard-nvim",
      cmd = {
          "Dashboard",
          "DashboardNewFile",
          "DashboardJumpMarks",
          "SessionLoad",
          "SessionSave"
      },
      setup = function()
          require("pconfig.c-dashboard").config()
      end
  }

  -- Git Support
  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    },
    config = function()
      require 'pconfig.c-gitsigns'
    end,
  }

  -- LSP Support
  use {
    'ljmf00/nvim-lspconfig',
    branch = 'patch-1',
    config = function()
      require 'pconfig.c-lsp'
    end,
  }

  -- Find: Telescope fuzzy finder
  use {
    'nvim-telescope/telescope.nvim',
    requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
  }
  use {"nvim-telescope/telescope-fzf-native.nvim", run = "make", cmd = "Telescope"}
  use {
      "nvim-telescope/telescope-media-files.nvim",
      cmd = "Telescope"
  }

  -- Autocomplete
  use {
    'hrsh7th/nvim-compe',
    config = function()
      require 'pconfig.c-compe'
    end,
  }

  -- Autopairs
  use {
    "windwp/nvim-autopairs",
    config = function()
      require 'pconfig.c-autopairs'
    end,
  }

  -- Snippets
  use 'SirVer/ultisnips'
  use { 'kiith-sa/DSnips', event = "InsertEnter" }
  use { "hrsh7th/vim-vsnip", event = "InsertEnter" }
  use { "rafamadriz/friendly-snippets", event = "InsertEnter" }

  -- Treesitter
  use 'nvim-treesitter/nvim-treesitter'

  -- NvimTree
  use {
    "kyazdani42/nvim-tree.lua",
    commit = "fd7f60e242205ea9efc9649101c81a07d5f458bb",
  }

  -- Comments
  use {
    "terrortylor/nvim-comment",
    event = "BufRead",
    config = function()
      local status_ok, nvim_comment = pcall(require, "nvim_comment")
      if not status_ok then
        return
      end
      nvim_comment.setup()
    end,
  }

  -- vim-rooter
  use {
    "airblade/vim-rooter",
    config = function()
      require 'pconfig.c-vrooter'
    end,
  }

  -- Icons
  use {
    'yamatsum/nvim-nonicons',
    requires = {'kyazdani42/nvim-web-devicons'}
  }

  -- Status Line and Bufferline
  use {
    'glepnir/galaxyline.nvim',
      branch = 'main',
      config = function() require'pconfig.c-galaxyline' end,
      requires = {'kyazdani42/nvim-web-devicons', opt = true},
  }
  use {
    'akinsho/nvim-bufferline.lua',
    config = function() require'pconfig.c-bufferline' end,
    requires = {'kyazdani42/nvim-web-devicons', opt = true},
  }
end)
