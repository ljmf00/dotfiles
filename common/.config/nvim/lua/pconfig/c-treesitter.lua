treesitter = require('nvim-treesitter.configs')

treesitter.setup {
  ensure_installed = {
    "bash",
    "c",
    "c_sharp",
    "cmake",
    "cpp",
    "css",
    "d",
    "go",
    "javascript",
    "json",
    "kotlin",
    "latex",
    "llvm",
    "lua",
    "make",
    "ninja",
    "php",
    "proto",
    "r",
    "ruby",
    "rust",
    "scala",
    "scss",
    "toml",
    "verilog",
    "vim",
    "vue",
    "yaml",
    "zig",
  },
  sync_install = false,

  autopairs = {
    enable = true,
  },

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}
