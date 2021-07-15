vim.cmd 'syntax enable'

-- Enable encoding
vim.o.encoding = "utf-8"

-- Tricks to make vim fast
vim.o.ttyfast = true

-- Terminal colors
vim.opt.termguicolors = true

-- Theme
vim.cmd 'colorscheme sonokai'
vim.o.background = 'dark'

-- Editor settings
--  Cursor
vim.o.cursorline = true
vim.o.showmatch = true
--  Relative lines
vim.o.number = true
--  Ruler
vim.o.cc = '80'
--  Whitespace rendering
vim.o.list = true
vim.o.listchars = 'tab:▸ ,extends:❯,precedes:❮,trail:·,nbsp:·'
vim.o.showbreak = '↪'
--  Indentation
vim.o.autoindent = true
vim.cmd 'filetype plugin indent on'
--  Hidden buffers
vim.o.hidden = true

-- Clipboard support
vim.cmd 'set clipboard+=unnamedplus'

-- Mouse support
vim.o.mouse = 'a'

-- Open terminal on insert mode automatically
vim.cmd 'autocmd TermOpen * startinsert'

vim.api.nvim_exec(
        [[
   au BufEnter term://* setlocal nonumber
   au BufEnter,BufWinEnter,WinEnter,CmdwinEnter * if bufname('%') == "NvimTree" | set laststatus=0 | else | set laststatus=2 | endif
   au BufEnter term://* set laststatus=0
]], false)
