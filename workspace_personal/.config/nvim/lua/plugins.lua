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
  use { '~/dotfiles/3rdparty/vim/schlepp' }
  --  File number on vim startup
  use { '~/dotfiles/3rdparty/vim/file-line' }
  --  Sensible default configs
  use { '~/dotfiles/3rdparty/vim/sensible' }
  --  Surround fast change
  use { '~/dotfiles/3rdparty/vim/surround' }
  --  Auto indentation
  use { '~/dotfiles/3rdparty/vim/sleuth' }
  --  Session manager
  use { '~/dotfiles/3rdparty/vim/obsession' }
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
  use { 'RRethy/vim-illuminate', commit = 'fb83d835eac50baeef49aac20c524a80727db0ac' }
  -- Smooth scroll
  use {
      "karb94/neoscroll.nvim",
      commit = '54c5c419f6ee2b35557b3a6a7d631724234ba97a',
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
    commit = 'db7cbcb40cc00fc5d6074d7569fb37197705e7f6',
    config = function()
      require 'pconfig.c-indent'
    end
  }

  -- Git Support
  use { 'tpope/vim-fugitive', tag = 'v3.4' }
  use {
    'lewis6991/gitsigns.nvim',
    tag = 'v0.5',
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

  -- Float terminal
  use 'voldikss/vim-floaterm'

  -- Autopairs
  use {
    "windwp/nvim-autopairs",
    commit = '6b6e35fc9aca1030a74cc022220bc22ea6c5daf4',
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

  -- Treesitter
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ":TSUpdate",
    config = function()
      require 'pconfig.c-treesitter'
    end,
  }

  -- NvimTree
  use {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require 'pconfig.c-nvimtree'
    end,
    commit = "7e892767bdd9660b7880cf3627d454cfbc701e9b",
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

  -- Icons
  use {
    'yamatsum/nvim-nonicons',
    requires = {'kyazdani42/nvim-web-devicons'}
  }

  -- Status Line and Bufferline
  -- FIXME: Find a better line
   use {
    "itchyny/lightline.vim",
    commit = "b1e91b41f5028d65fa3d31a425ff21591d5d957f",
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
