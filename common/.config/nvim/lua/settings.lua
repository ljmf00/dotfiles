vim.cmd 'syntax enable'

-- Enable encoding
vim.o.encoding = "utf-8"

-- Tricks to make vim fast
vim.o.ttyfast = true

-- Terminal colors
vim.opt.termguicolors = true

-- Float termina
vim.g['floaterm_height'] = 0.95
vim.g['floaterm_width'] = 0.95

-- Theme
vim.g['sonokai_style'] = 'default'
vim.g['sonokai_enable_italic'] = 1
vim.g['sonokai_disable_italic_comment'] = 1
vim.g['sonokai_diagnostic_text_highlight'] = 1
vim.g['sonokai_diagnostic_line_highlight'] = 1
vim.g['sonokai_diagnostic_virtual_text'] = 'colored'
vim.cmd 'silent! colorscheme sonokai'
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
vim.o.listchars = 'tab:→ ,extends:❯,precedes:❮,trail:·,nbsp:·,space:·'
-- vim.o.listchars = 'tab:▷▷⋮,extends:❯,precedes:❮,trail:·,nbsp:·,space:·'
vim.o.showbreak = '↪'
--  Indentation
vim.o.autoindent = true
vim.cmd 'filetype plugin indent on'
--  Hidden buffers
vim.o.hidden = true
-- Hidden mode
vim.o.showmode = false

-- Completion settings
vim.o.completeopt = "menuone,noselect,longest"

-- Clipboard support
vim.cmd 'set clipboard+=unnamedplus'

-- Mouse support
vim.o.mouse = 'a'

-- Terminal
--  Open terminal on insert mode automatically
vim.cmd 'autocmd TermOpen * startinsert'
--  Close terminal immediatly
vim.cmd 'au TermClose * call feedkeys("i")'

vim.api.nvim_exec(
        [[
   au BufEnter term://* setlocal nonumber
   au BufEnter,BufWinEnter,WinEnter,CmdwinEnter * if bufname('%') == "NvimTree" | set laststatus=0 | else | set laststatus=2 | endif
   au BufEnter term://* set laststatus=0

   augroup numbertoggle
     autocmd!
     autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
     autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
   augroup END
]], false)
