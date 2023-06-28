" Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" fancy colors
set termguicolors

" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^Eterm'
  set t_Co=16
endif

" use bash if we can
if v:version < 704 || v:version == 704 && !has('patch276')
  set shell=/usr/bin/env\ bash
endif

" add mouse support
set mouse=a

" clipboard support
if has('clipboard')
  set clipboard+=unnamedplus
endif

" Completion settings
set completeopt=menuone,noselect,longest

" enable syntax
if has('syntax')
  syntax enable
endif

" Disable vi compatibility, if for some reason it's on.
if &compatible
  set nocompatible
endif

" Disable a legacy behavior that can break plugin maps.
if has('langmap') && exists('+langremap') && &langremap
  set nolangremap
endif

" set backspace behaviour
set backspace=indent,eol,start

" Disable completing keywords in included files (e.g., #include in C).  When
" configured properly, this can result in the slow, recursive scanning of
" hundreds of files of dubious relevance.
set complete-=i

" enable smart tab
set smarttab

" don't format in octal
set nrformats-=octal

" set automatic indent
set autoindent

" improve responsiveness
set ttyfast

" Make the escape key more responsive by decreasing the wait time for an
" escape sequence (e.g., arrow keys).
if !has('nvim') && &ttimeoutlen == -1
  set ttimeout
  set ttimeoutlen=100
endif

if has('reltime')
  set incsearch
endif

" cursor line
set cursorline
" show match on the cursor
set showmatch

" relative cursor
set number

" ruler and ruler limit
set ruler
set cc=80

" scroll behaviour
set scrolloff=1
set sidescroll=1
set sidescrolloff=2

" whitespace rendering
set list
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+

" session related settings

" Saving options in session and view files causes more problems than it
" solves, so disable it.
set sessionoptions-=options
set viewoptions-=options

" misc
set laststatus=2
set wildmenu

set history=1000
set tabpagemax=50

set display+=lastline
if has('patch-7.4.2109')
  set display+=truncate
endif

" Delete comment character when joining commented lines.
if v:version > 703 || v:version == 703 && has("patch541")
  set formatoptions+=j
endif

" Replace the check for a tags file in the parent directory of the current
" file with a check in every ancestor directory.
if has('path_extra') && (',' . &g:tags . ',') =~# ',\./tags,'
  setglobal tags-=./tags tags-=./tags; tags^=./tags;
endif

" Persist g:UPPERCASE variables, used by some plugins, in .viminfo.
if !empty(&viminfo)
  set viminfo^=!
endif

" From `:help :DiffOrig`.
if exists(":DiffOrig") != 2
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_
        \ | diffthis | wincmd p | diffthis
endif

" Correctly highlight $() and other modern affordances in filetype=sh.
if !exists('g:is_posix') && !exists('g:is_bash') && !exists('g:is_kornshell') && !exists('g:is_dash')
  let g:is_posix = 1
endif

" Keybindings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Remap leader key
let g:mapleader = " "

" set paste toggle keymap
set pastetoggle=<F2>

" Use CTRL-L to clear the highlighting of 'hlsearch' (off by default) and call
" :diffupdate.
nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>

inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>

" Smart Home key
noremap  <expr> <Home> col('.') == match(getline('.'), '\S') + 1 ? "\<Home>" : "^"
inoremap <expr> <Home> col('.') == match(getline('.'), '\S') + 1 ? "\<Home>" : "\<C-O>^"

" Auto command bootstrap
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if has('autocmd')
  " enable plugin indent
  filetype plugin indent on

  autocmd TermOpen * startinsert
  au TermClose * call feedkeys("i")

  au BufEnter term://* setlocal nonumber
  au BufEnter,BufWinEnter,WinEnter,CmdwinEnter * if bufname('%') == "NvimTree" | set laststatus=0 | else | set laststatus=2 | endif
  au BufEnter term://* set laststatus=0

  augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
    autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
  augroup END
endif

if v:version >= 701
  " below regexp will separate filename and line/column number
  " possible inputs to get to line 10 (and column 99) in code.cc are:
  " * code.cc(10)
  " * code.cc(10:99)
  " * code.cc:10
  " * code.cc:10:99
  "
  " closing braces/colons are ignored, so also acceptable are:
  " * code.cc(10
  " * code.cc:10:
  let s:regexpressions = [ '\(.\{-1,}\)[(:]\(\d\+\)\%(:\(\d\+\):\?\)\?' ]

  function! s:reopenAndGotoLine(file_name, line_num, col_num)
          if !filereadable(a:file_name)
                  return
          endif

          let l:bufn = bufnr("%")

          exec "keepalt edit " . fnameescape(a:file_name)
          exec a:line_num
          exec "normal! " . a:col_num . '|'
          if foldlevel(a:line_num) > 0
                  exec "normal! zv"
          endif
          exec "normal! zz"

          exec "bwipeout " l:bufn
          exec "filetype detect"
  endfunction

  function! s:gotoline()
          let file = bufname("%")

          " :e command calls BufRead even though the file is a new one.
          " As a workaround Jonas Pfenniger<jonas@pfenniger.name> added an
          " AutoCmd BufRead, this will test if this file actually exists before
          " searching for a file and line to goto.
          if (filereadable(file) || file == '')
                  return file
          endif

          let l:names = []
          for regexp in s:regexpressions
                  let l:names =  matchlist(file, regexp)

                  if ! empty(l:names)
                          let file_name = l:names[1]
                          let line_num  = l:names[2] == ''? '0' : l:names[2]
                          let  col_num  = l:names[3] == ''? '0' : l:names[3]
                          call s:reopenAndGotoLine(file_name, line_num, col_num)
                          return file_name
                  endif
          endfor
          return file
  endfunction

  " Handle entry in the argument list.
  " This is called via `:argdo` when entering Vim.
  function! s:handle_arg()
          let argname = expand('%')
          let fname = s:gotoline()
          if fname != argname
                  let argidx = argidx()
                  exec (argidx+1).'argdelete'
                  exec (argidx)'argadd' fnameescape(fname)
          endif
  endfunction

  function! s:startup()
          autocmd BufNewFile * nested call s:gotoline()
          autocmd BufRead * nested call s:gotoline()

          if argc() > 0
                  let argidx=argidx()
                  silent call s:handle_arg()
                  exec (argidx+1).'argument'
                  " Manually call Syntax autocommands, ignored by `:argdo`.
                  doautocmd Syntax
                  doautocmd FileType
          endif
  endfunction

  if !isdirectory(expand("%:p"))
          autocmd VimEnter * call s:startup()
  endif
endif

" vim:set ft=vim et sw=2:
