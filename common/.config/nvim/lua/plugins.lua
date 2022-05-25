local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end

return require('packer').startup(function()
  -- Packer
  use '~/dotfiles/3rdparty/vim/packer.nvim'

  -- Theme
  use {
    '~/dotfiles/3rdparty/vim/sonokai',
    requires = {
      'neomake/neomake',
      'nvim-treesitter/nvim-treesitter',
      'yamatsum/nvim-nonicons',
      'itchyny/lightline.vim'
    },
  }

  -- Wakatime
  use { '~/dotfiles/3rdparty/vim/wakatime' }

  -- Misc settings

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
  -- Indent guidelines
  use {
    "lukas-reineke/indent-blankline.nvim",
    commit = '1b852dcb92fbef837ff6a0ef0f9269e4fd234370',
    config = function()
      require 'pconfig.c-indent'
    end
  }

  -- Git Support
  use { 'tpope/vim-fugitive', tag = 'v3.4' }
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
    'neovim/nvim-lspconfig',
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
    end
  }

  -- Autocomplete
  use {
    'ms-jpq/coq_nvim',
    branch = "coq",
    config = function()
      require 'pconfig.c-coq'
    end,
    requires = {
      'ms-jpq/coq.artifacts',
      'ms-jpq/coq.thirdparty',
      'neovim/nvim-lspconfig'
    }
  }
  use { 'ms-jpq/coq.artifacts', branch = "artifacts" }
  use { 'ms-jpq/coq.thirdparty', branch = "3p" }

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
    commit = "2e33b1654384921ec1cc9656a2018744f3f1ce81",
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
  -- use {
  --   "airblade/vim-rooter",
  --   config = function()
  --     require 'pconfig.c-vrooter'
  --   end,
  -- }

  -- Icons
  use {
    'yamatsum/nvim-nonicons',
    requires = {'kyazdani42/nvim-web-devicons'}
  }

  -- Status Line and Bufferline
  -- FIXME: Find a better line
   use {
    "itchyny/lightline.vim",
    commit = "b06d921023cf6536bcbee5754071d122296e8942",
    config = function ()
      require 'pconfig.c-lightline'
    end
   }
  use {
    'akinsho/bufferline.nvim',
    commit = 'cebafb95622205a414a6c10bf0e40d197cc652b1',
    config = function() require'pconfig.c-bufferline' end,
    requires = {'kyazdani42/nvim-web-devicons', opt = true},
  }
end)
