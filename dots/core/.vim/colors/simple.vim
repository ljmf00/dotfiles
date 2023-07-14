" simple vim theme

" Cleaning procedures
if version > 580

  " Set 'background' back to the default.  The value can't always be estimated
  " and is then guessed.
  highlight clear Normal
  set bg&

  " Remove all existing highlighting and set the defaults.
  highlight clear

  " Load the syntax highlighting defaults, if it's enabled.
  if exists("syntax_on")
    syntax reset
  endif

endif

" Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" colorscheme name
let g:colors_name = 'simple'

" Bootstrap
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let s:t_Co = (exists('&t_Co') && !has('gui_running')) ? (&t_Co) : -1

" Don't proceed if no support for terminal gui colors
if !(has('termguicolors') && &termguicolors) && !has('gui_running') && &t_Co != 256
  finish
endif

if (&background == 'dark')
  set background=dark
else
  set background=light
endif

" Utility
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let s:palette = {
  \ 'black':             ['#000000',    'black'],
  \ 'white':             ['#ffffff',    'white'],
  \ 'darkgrey':          ['#151515', 'darkgrey'],
  \ 'grey':              ['#a0a0a0',     'grey'],
  \ 'lightgrey':         ['#cccccc','lightgrey'],
  \ 'red':               ['#ff0000',      'red'],
  \ 'orange':            ['#ffa500',      '215'],
  \ 'blue':              ['#0000ff',     'blue'],
  \ 'green':             ['#00ff00',    'green'],
  \ 'cyan':              ['#00ffff',     'cyan'],
  \ 'yellow':            ['#ffff00',   'yellow'],
  \ 'magenta':           ['#ff00ff',  'magenta'],
  \ 'none':              [   'NONE',     'NONE']
  \ }

if (&background == 'dark')
  let s:palette.bg  = s:palette.black
  let s:palette.bg2 = s:palette.darkgrey
  let s:palette.fg  = s:palette.white
  let s:palette.fg2  = s:palette.lightgrey
else
  let s:palette.bg = s:palette.white
  let s:palette.bg2 = s:palette.lightgrey
  let s:palette.fg = s:palette.black
  let s:palette.fg2 = s:palette.darkgrey
endif

function! s:HL(group, fg, ...)
  " Arguments: group, guifg, guibg, gui, guisp

  " foreground
  let fg = a:fg

  " background
  if a:0 >= 1
    let bg = a:1
  else
    let bg = s:palette.none
  endif

  " emphasis
  if a:0 >= 2 && strlen(a:2)
    let emstr = a:2
  else
    let emstr = 'NONE,'
  endif

  let histring = [ 'hi', a:group,
        \ 'guifg=' . fg[0], 'ctermfg=' . fg[1],
        \ 'guibg=' . bg[0], 'ctermbg=' . bg[1],
        \ 'gui=' . emstr[:-2], 'cterm=' . emstr[:-2]
        \ ]

  " special
  if a:0 >= 3
    call add(histring, 'guisp=' . a:3[0])
  endif

  execute join(histring, ' ')
endfunction

" for external usage
call s:HL('Background', s:palette.bg)
call s:HL('Foreground', s:palette.fg)

" Colorscheme
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if version >= 700
  " Tab pages line filler
  call s:HL('TabLineFill', s:palette.fg2, s:palette.bg2)
  " Active tab page label
  call s:HL('TabLineSel', s:palette.fg, s:palette.bg2)
  " Not active tab page label
  highlight! link TabLine TabLineFill
endif

if version >= 703
  " Highlighted screen columns
  call s:HL('ColorColumn', s:palette.none, s:palette.bg2)

  " Concealed element: \lambda → λ
  call s:HL('Conceal', s:palette.blue, s:palette.none)
endif

" Text Modes
call s:HL('Normal',     s:palette.fg, s:palette.bg)
call s:HL('Visual',     s:palette.none, s:palette.bg2)
hi! link VisualNOS Visual

highlight! link NormalNC Normal
highlight! link Terminal Normal

" Special text
call s:HL('NonText',    s:palette.bg2)
call s:HL('SpecialKey', s:palette.bg2)

" Indent guides
call s:HL('Underlined', s:palette.none, s:palette.none, 'underline,')
call s:HL('IndentGuidesOdd', s:palette.none, s:palette.bg2)
call s:HL('IndentGuidesEven', s:palette.none, s:palette.bg2)

let g:indentLine_color_gui = s:palette.bg2[0]
let g:indentLine_color_term = s:palette.bg2[1]

call s:HL('IndentBlanklineContextChar', s:palette.fg2, s:palette.none, 'nocombine,')
call s:HL('IndentBlanklineChar', s:palette.bg2, s:palette.none, 'nocombine,')
highlight! link IndentBlanklineSpaceChar IndentBlanklineChar
highlight! link IndentBlanklineSpaceCharBlankline IndentBlanklineChar

call s:HL('Ignore',  s:palette.grey                                  )
call s:HL('Todo',    s:palette.black,     s:palette.yellow, 'bold,'  )
call s:HL('Comment', s:palette.lightgrey, s:palette.none,   'italic,')

highlight! link SpecialComment Comment

call s:HL('Identifier',   s:palette.fg)

call s:HL('Macro',           s:palette.magenta)
call s:HL('Label',           s:palette.magenta)
call s:HL('Constant',        s:palette.magenta, s:palette.none, 'italic,')
call s:HL('Variable',        s:palette.orange)
call s:HL('Tag',             s:palette.orange)
call s:HL('Type',            s:palette.cyan)
call s:HL('TypeBuiltin',     s:palette.cyan, s:palette.none, 'italic,')
call s:HL('TypeDefinition',  s:palette.cyan, s:palette.none, 'italic,')
call s:HL('Structure',       s:palette.cyan)
call s:HL('StorageClass',    s:palette.cyan)
call s:HL('Function',        s:palette.green)
call s:HL('Statement',       s:palette.red)
call s:HL('Operator',        s:palette.red)

call s:HL('Builtin',         s:palette.green, s:palette.none, 'italic,')
highlight! link VariableBuiltin Builtin
highlight! link FunctionBuiltin Builtin

call s:HL('Keyword',        s:palette.red)
call s:HL('Define',         s:palette.red)
call s:HL('Title',          s:palette.red)
call s:HL('Include',        s:palette.red)
call s:HL('Typedef',        s:palette.red)
call s:HL('Exception',      s:palette.red)
call s:HL('Conditional',    s:palette.red)
call s:HL('Repeat',         s:palette.red)
call s:HL('PreProc',        s:palette.red)
call s:HL('PreCondit',      s:palette.red)

call s:HL('String',         s:palette.yellow)
call s:HL('Character',      s:palette.yellow)
call s:HL('Special',        s:palette.magenta)
call s:HL('SpecialChar',    s:palette.magenta)

call s:HL('Boolean',        s:palette.magenta)
call s:HL('Number',         s:palette.magenta)
call s:HL('Float',          s:palette.magenta)

call s:HL('Delimiter',      s:palette.grey)

if version >= 700
  call s:HL('MatchParen',   s:palette.none, s:palette.bg2, 'underline,')
endif

" Errors
call s:HL('Error',          s:palette.red)

" Cursor
call s:HL('Cursor', s:palette.none, s:palette.none, 'reverse,')

highlight! link vCursor    Cursor
highlight! link iCursor    Cursor
highlight! link lCursor    Cursor
highlight! link CursorIM   Cursor
highlight! link TermCursor Cursor

call s:HL('CursorLineNr', s:palette.fg,   s:palette.bg2)
call s:HL('CursorLine',   s:palette.none, s:palette.bg2)
highlight! link CursorColumn   CursorLine
highlight! link CursorLineFold CursorLine
highlight! link CursorLineSign CursorLine

call s:HL('Search',   s:palette.bg, s:palette.green)
highlight! link CurSearch Search
highlight! link CurSearch IncSearch

call s:HL('LineNr', s:palette.grey, s:palette.bg2)
highlight! link LineNrAbove LineNr
highlight! link LineNrBelow LineNr

" Window
call s:HL('SignColumn', s:palette.none, s:palette.bg2)
call s:HL('VertSplit', s:palette.darkgrey)

highlight! link StatuslineTerm Statusline
highlight! link StatuslineTermNC StatuslineNC
highlight! link MessageWindow Pmenu
highlight! link PopupNotification Todo

" Menu
call s:HL('Pmenu',     s:palette.fg,   s:palette.bg)
call s:HL('PmenuSbar', s:palette.none, s:palette.bg)
call s:HL('PmenuSel',  s:palette.fg,   s:palette.blue)

highlight! link TelescopeSelection PmenuSel

" For nvim specific configurations
if has('nvim')
  call s:HL('WinBarNC', s:palette.grey)

  " Alias to vim highlight definitions
  if has('nvim-0.8.0')
    highlight! link @error Error

    highlight! link @comment Comment

    highlight! link @boolean Boolean

    highlight! link @character Character
    highlight! link @character.special SpecialChar
  endif
endif

" Treesitter
highlight! link TSError           Error

highlight! link TSBoolean         Boolean
highlight! link TSNumber          Number

highlight! link TSCharacter       Character

highlight! link TSPunctBracket    Delimiter
highlight! link TSPunctDelimiter  Delimiter

highlight! link TSMethod          Function
highlight! link TSMethodCall      Function

highlight! link TSVariable        Variable
highlight! link TSVariableBuiltin VariableBuiltin

" Gitsigns
call s:HL('GitSignsAdd',              s:palette.green, s:palette.bg2)
call s:HL('GitSignsAddNr',            s:palette.green, s:palette.bg2)
call s:HL('GitSignsAddLn',            s:palette.green, s:palette.bg2)

call s:HL('GitSignsChange',           s:palette.blue, s:palette.bg2)
call s:HL('GitSignsChangeNr',         s:palette.blue, s:palette.bg2)
call s:HL('GitSignsChangeLn',         s:palette.blue, s:palette.bg2)

call s:HL('GitSignsDelete',           s:palette.red, s:palette.bg2)
call s:HL('GitSignsDeleteNr',         s:palette.red, s:palette.bg2)
call s:HL('GitSignsDeleteLn',         s:palette.red, s:palette.bg2)

call s:HL('GitSignsCurrentLineBlame', s:palette.grey)

" Floaterm
call s:HL('FloatermBorder', s:palette.grey)

" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker:
