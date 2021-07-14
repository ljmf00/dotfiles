set encoding=utf-8

" Tricks to make vim fast
set ttyfast

if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent ! curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

" Plugins
call plug#begin('~/.config/nvim/plugged')

" Custom status bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Colors and highlighting
Plug 'lifepillar/vim-solarized8'
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
Plug 'RRethy/vim-illuminate'

Plug 'tpope/vim-sensible'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-obsession'

" Tabs
Plug 'kyazdani42/nvim-web-devicons'
Plug 'romgrk/barbar.nvim'

Plug 'tpope/vim-git'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'APZelos/blamer.nvim'

Plug 'bogado/file-line'
Plug 'preservim/nerdtree'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'
Plug 'windwp/nvim-autopairs'

Plug 'SirVer/ultisnips'
Plug 'kiith-sa/DSnips'

" Fuzzy finding
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

call plug#end()

if exists('g:loaded_sensible') || &compatible
  finish
else
  let g:loaded_sensible = 'yes'
endif

syntax enable

" Solarized Dark theme
colorscheme solarized8
set termguicolors
set background=dark
hi Normal guibg=#002b37

set cursorline
set number relativenumber
set showmatch

set clipboard+=unnamedplus

" FIXME: Don't toggle this on NERDTree
augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
    autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

set list
set listchars=tab:▸\ ,extends:❯,precedes:❮,trail:·,nbsp:·
set showbreak=↪

filetype plugin indent on

let g:indentLine_char = '▏'
let g:deoplete#enable_at_startup = 1

let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '⚠'

let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_theme='powerlineish'

let g:airline#extensions#tabline#formatter = 'unique_tail_improved'

let g:Hexokinase_highlighters = [ 'virtual' ]

" Snippets configurations
let g:UltiSnipsExpandTrigger="<tab>"

" Lazy line move
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==
inoremap <C-j> <ESC>:m .+1<CR>==gi
inoremap <C-k> <ESC>:m .-2<CR>==gi
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv

" Smooth scroll
set mouse=a

" Auto indentation
  set smartindent
  set tabstop=8
  set softtabstop=4
  set shiftwidth=4
  set expandtab

  set autoindent
  set backspace=indent,eol,start
  set complete-=i
  set smarttab

  let g:dutyl_dontHandleFormat = 1
  let g:dutyl_dontHandleIndent = 1

  set nrformats-=octal

" LSP
lua << EOF
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  require'lspconfig'.vimls.setup{}
  require'lspconfig'.serve_d.setup{}
  vim.o.completeopt = "menuone,noselect"

  require'compe'.setup {
    enabled = true;
    autocomplete = true;
    debug = false;
    min_length = 1;
    preselect = 'enable';
    throttle_time = 80;
    source_timeout = 200;
    resolve_timeout = 800;
    incomplete_delay = 400;
    max_abbr_width = 100;
    max_kind_width = 100;
    max_menu_width = 100;
    documentation = {
      border = { '', '' ,'', ' ', '', '', '', ' ' }, -- the border option is the same as `|help nvim_open_win|`
      winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
      max_width = 120,
      min_width = 60,
      max_height = math.floor(vim.o.lines * 0.3),
      min_height = 1,
    };

    source = {
      path = true;
      buffer = true;
      calc = true;
      nvim_lsp = true;
      nvim_lua = true;
      vsnip = true;
      ultisnips = true;
      luasnip = true;
    };
  }
  require('nvim-autopairs').setup()
  require("nvim-autopairs.completion.compe").setup({
    map_cr = true, --  map <CR> on insert mode
    map_complete = true -- it will auto insert `(` after select function or method item
  })

  vim.lsp.set_log_level("debug")
EOF

" Autocompletion
  inoremap <silent><expr> <C-Space> compe#complete()
  inoremap <silent><expr> <CR>      compe#confirm(luaeval("require 'nvim-autopairs'.autopairs_cr()"))
  inoremap <silent><expr> <C-e>     compe#close('<C-e>')
  inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
  inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

" D error parsing
  autocmd FileType d set efm=%*[^@]@%f\(%l\):\ %m,%f\(%l\\,%c\):\ %m,%f\(%l\):\ %m

autocmd StdinReadPre * let s:std_in=1

" Don't show relative line numbers in taglists
  autocmd FileType taglist set norelativenumber

" NERDTree
  autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
  autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

  autocmd FileType nerdtree set norelativenumber

  let g:NERDTreeDirArrowExpandable = '▸'
  let g:NERDTreeDirArrowCollapsible = '▾'
  let g:NERDTreeShowLineNumbers=0

  nnoremap <silent> <C-b> <cmd>NERDTreeToggle<CR>

" Open terminal on insert mode automatically
  autocmd TermOpen * startinsert

" Navigation
  let mapleader=","

  nnoremap <C-p> <cmd>lua vim.lsp.diagnostic.goto_prev()<cr>
  nnoremap <C-n> <cmd>lua vim.lsp.diagnostic.goto_next()<cr>
  nnoremap <C-Space> <cmd>lua vim.lsp.buf.hover()<cr>

  nnoremap <leader>gD <cmd>lua vim.lsp.buf.declaration()<cr>
  nnoremap <leader>gd <cmd>Telescope lsp_definitions<cr>
  nnoremap <leader>gi <cmd>Telescope lsp_implementations<cr>
  nnoremap <leader>gr <cmd>Telescope lsp_references<cr>
  nnoremap <leader>ff <cmd>Telescope find_files<cr>
  nnoremap <leader>fg <cmd>Telescope live_grep<cr>
  nnoremap <leader>fb <cmd>Telescope buffers<cr>
  nnoremap <leader>fh <cmd>Telescope help_tags<cr>
  nnoremap <leader>fds <cmd>Telescope lsp_document_symbols<cr>
  nnoremap <leader>fws <cmd>Telescope lsp_dynamic_workspace_symbols<cr>
  nnoremap <leader>fdd <cmd>Telescope lsp_document_diagnostics<cr>
  nnoremap <leader>fwd <cmd>Telescope lsp_workspace_diagnostics<cr>
