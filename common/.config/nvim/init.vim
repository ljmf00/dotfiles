set encoding=utf-8

if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent ! curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.config/nvim/plugged')

" Plugins
Plug 'crusoexia/vim-monokai'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'terryma/vim-multiple-cursors'
Plug 'lilydjwg/colorizer'
Plug 'cohama/lexima.vim'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'
Plug 'bogado/file-line'
Plug 'tpope/vim-git'
Plug 'RRethy/vim-illuminate'
Plug 'airblade/vim-gitgutter'
Plug 'JesseKPhillips/d.vim'
Plug 'idanarye/vim-dutyl'
Plug 'tbastos/vim-lua'
Plug 'matze/vim-meson'
Plug 'itspriddle/vim-shellcheck'
Plug 'honza/dockerfile.vim'
Plug 'othree/html5.vim'
Plug 'martin-svk/vim-yaml'
Plug 'tpope/vim-markdown'
Plug 'Yggdroot/indentLine'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'SirVer/ultisnips'

call plug#end()

syntax on
colorscheme monokai
set number

set termguicolors
set t_Co=256

let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '⚠'

let g:monokai_term_italic = 1
let g:monokai_gui_italic = 1

set list
set listchars=tab:▸\ ,extends:❯,precedes:❮,trail:·,nbsp:·
set showbreak=↪

filetype plugin on
filetype indent on

let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_theme='powerlineish'

let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

let g:airline#extensions#tabline#formatter = 'unique_tail_improved'

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

let g:indentLine_char = '▏'
let g:deoplete#enable_at_startup = 1

