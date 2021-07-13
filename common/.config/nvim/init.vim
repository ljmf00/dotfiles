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

" Smooth scrolling
Plug 'yuttie/comfortable-motion.vim'

Plug 'tpope/vim-sensible'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'

Plug 'tpope/vim-git'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'APZelos/blamer.nvim'

Plug 'bogado/file-line'
Plug 'preservim/nerdtree'

Plug 'prabirshrestha/vim-lsp'
Plug 'SirVer/ultisnips'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'thomasfaingnaert/vim-lsp-snippets'
Plug 'thomasfaingnaert/vim-lsp-ultisnips'
Plug 'honza/vim-snippets'

" Dlang support
Plug 'idanarye/vim-dutyl'
Plug 'kiith-sa/DSnips'

call plug#end()

if exists('g:loaded_sensible') || &compatible
  finish
else
  let g:loaded_sensible = 'yes'
endif

if has('autocmd')
  filetype plugin indent on
endif
if has('syntax') && !exists('g:syntax_on')
  syntax enable
endif

if !has('nvim') && &ttimeoutlen == -1
  set ttimeout
  set ttimeoutlen=100
endif

" Solarized Dark theme
colorscheme solarized8
set termguicolors
set background=dark
hi Normal guibg=#002b37

set cursorline
set number relativenumber
set showmatch

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

let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

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

let g:comfortable_motion_friction = 80.0
let g:comfortable_motion_air_drag = 2.0

" Autoclose brackets
inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O

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

noremap <silent> <ScrollWheelDown> :call comfortable_motion#flick(20)<CR>
noremap <silent> <ScrollWheelUp>   :call comfortable_motion#flick(-20)<CR>

autocmd FileType d set efm=%*[^@]@%f\(%l\):\ %m,%f\(%l\\,%c\):\ %m,%f\(%l\):\ %m

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

