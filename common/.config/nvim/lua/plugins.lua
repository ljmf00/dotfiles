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
    commit = 'ef631befe2bea01c23f4f0d9685025ac15d51ace',
    config = function()
      require 'pconfig.c-sonokai'
    end,
  }

  -- Wakatime
  use { 'wakatime/vim-wakatime', tag = '8.0.0' }

  -- Misc settings

  --  Auto relative number toggle
  use { 'jeffkreeftmeijer/vim-numbertoggle', tag = '2.1.2' }
  --  Move lines around
  use { 'zirrostig/vim-schlepp', tag = 'v1.0.1' }
  --  File number on vim startup
  use { 'bogado/file-line', tag = '1.0' }
  --  Sensible default configs
  use { 'tpope/vim-sensible', tag = 'v1.2' }
  --  Surround fast change
  use { 'tpope/vim-surround', tag = 'v2.1' }
  --  Auto indentation
  use { 'tpope/vim-sleuth', tag = 'v1.2' }
  --  Session manager
  use { 'tpope/vim-obsession', commit = '82c9ac5e130c92a46e043dd9cd9e5b48d15e286d' }
  --  Color code highlighter
  use {
    'rrethy/vim-hexokinase',
    commit = '62324b43ea858e268fb70665f7d012ae67690f43',
    run = 'make hexokinase',
    config = function()
      require 'pconfig.c-hexokinase'
    end,
  }
  --  Highlight similar words
  use { 'RRethy/vim-illuminate', commit = '8fe150bd775f659da7e40ea2d3ad7473e6d29494' }
  -- Smooth scroll
  use {
      "karb94/neoscroll.nvim",
      commit = '2b0d9b2db68995bf3fd280523dc192ca602e8367',
      event = "WinScrolled",
      config = function()
          require("neoscroll").setup()
      end
  }
  --  Custom dashboard
  use {
      "glepnir/dashboard-nvim",
      commit = 'ba98ab86487b8eda3b0934b5423759944b5f7ebd',
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
    tag = 'v0.2',
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

  -- Tagbar
  use {
    'preservim/tagbar',
    tag = 'v3.0.0'
  }

  -- Better make command
  use {
    'neomake/neomake',
    config = function()
      require 'pconfig.c-neomake'
    end
  }

  -- Find: Telescope fuzzy finder
  use {
    'nvim-telescope/telescope.nvim',
    requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
  }
  use {
    "nvim-telescope/telescope-fzf-native.nvim",
    requires = { 'nvim-telescope/telescope.nvim' },
    run = "make",
    cmd = "Telescope"
  }
  use {
    "nvim-telescope/telescope-media-files.nvim",
    requires = { 'nvim-telescope/telescope.nvim' },
    cmd = "Telescope"
  }

  -- Autopairs
  use {
    "windwp/nvim-autopairs",
    commit = 'e599e15f9400e6b587e3160d2dff83764cb4ab7d',
    config = function()
      require 'pconfig.c-autopairs'
    end,
    requires = { 'hrsh7th/nvim-compe' }
  }

  -- Autocomplete
  use {
    'hrsh7th/nvim-compe',
    tag = 'v2.0.0',
    config = function()
      require 'pconfig.c-compe'
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
    config = function()
      require 'pconfig.c-nvimtree'
    end,
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
    commit = 'd544cb9d0b56f6ef271db3b4c3cf19ef665940d5',
    config = function() require'pconfig.c-galaxyline' end,
    requires = {'kyazdani42/nvim-web-devicons', opt = true},
  }
  use {
    'akinsho/nvim-bufferline.lua',
    commit = 'cebafb95622205a414a6c10bf0e40d197cc652b1',
    config = function() require'pconfig.c-bufferline' end,
    requires = {'kyazdani42/nvim-web-devicons', opt = true},
  }
end)
