return {
  -- buffer line
  {
    dir = '~/dotfiles/dist/3rdparty/nvim/barbar.nvim',
    dependencies = {
      'lewis6991/gitsigns.nvim',
    },
    init = function() vim.g.barbar_auto_setup = false end,
    opts = {
      icons = {
        button   = 'x',
        inactive = { button = 'x' },
        filetype = {
          enabled = false,
        },
        separator = { left = '|', right = '' },
        modified  = { button = '*' },
      }
    },
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

  -- wakatime
  { dir = '~/dotfiles/dist/3rdparty/vim/wakatime' },

  -- move lines around
  {
    dir = '~/dotfiles/dist/3rdparty/vim/schlepp',
    init = function()
      vim.cmd 'silent! source ~/.config/nvim/lua/plugconf/schlepp.vim'
    end,
  },

  -- Indent guidelines
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require('plugconf/indentblank')
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeOpen", "NvimTreeClose", "NvimTreeToggle", "NvimTreeFocus" },
    opts = function()
      return require "plugconf/nvimtree"
    end,
    config = function(_, opts)
      require("nvim-tree").setup(opts)
      vim.g.nvimtree_side = opts.view.side
    end,
  },

  {
    dir = '~/dotfiles/dist/3rdparty/vim/neomake',
    config = function()
      require('plugconf/neomake')
    end,
  },

  {
    'lewis6991/gitsigns.nvim',
    ft = { "gitcommit", "diff" },
    tag = 'v0.5',
    dependencies = {
      { dir = '~/dotfiles/dist/3rdparty/nvim/plenary' },
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
    dir = '~/dotfiles/dist/3rdparty/nvim/lspconfig',
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
    dir = '~/dotfiles/dist/3rdparty/nvim/telescope',
    cmd = "Telescope",

    dependencies = {
      { dir = '~/dotfiles/dist/3rdparty/nvim/plenary' },
      'nvim-lua/popup.nvim',
      'BurntSushi/ripgrep',

      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      { 'nvim-telescope/telescope-media-files.nvim' },
    },

    config = function()
      require('plugconf/telescope')
    end,
  },
}
