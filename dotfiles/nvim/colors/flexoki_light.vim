" Name:         flexoki_light
" Description:  Flexoki light for Vim. Port of kepano/flexoki-neovim light variant.
" URL:          https://stephango.com/flexoki
" Review:       verified against :help color-schemes, :help highlight, :help cterm-colors,
"               $VIMRUNTIME/colors/README.txt and lua/flexoki/highlights/base.lua (upstream).
" Corrections:  see fix/doc notes below.

set background=light
hi clear

if exists('syntax_on')
  syntax reset
endif

" fix: g:color_name (singular) does nothing. Doc :help :colorscheme -> it is
" g:colors_name (plural) that registers the name displayed by :colorscheme.
let g:colors_name = 'flexoki_light'

" doc $VIMRUNTIME/colors/README.txt: a colorscheme must not force
" 'termguicolors' (it belongs to the vimrc). Already present in ~/.vimrc (set termguicolors).
" Removes the original set termguicolors block.

" Flexoki light (hex values identical to flexoki-neovim palette.lua)

let s:base = {}
let s:base.flexoki_black       = '#100F0F'
let s:base.flexoki_paper       = '#FFFCF0'
let s:base.flexoki_950         = '#1C1B1A'
let s:base.flexoki_900         = '#282726'
let s:base.flexoki_850         = '#343331'
let s:base.flexoki_800         = '#403E3C'
let s:base.flexoki_700         = '#575653'
let s:base.flexoki_600         = '#6F6E69'
let s:base.flexoki_500         = '#878580'
let s:base.flexoki_300         = '#B7B5AC'
let s:base.flexoki_200         = '#CECDC3'
let s:base.flexoki_150         = '#DAD8CE'
let s:base.flexoki_100         = '#E6E4D9'
let s:base.flexoki_50          = '#F2F0E5'

let s:base.flexoki_red_600     = '#AF3029'
let s:base.flexoki_red_400     = '#D14D41'

let s:base.flexoki_orange_600  = '#BC5215'
let s:base.flexoki_orange_400  = '#DA702C'

let s:base.flexoki_yellow_900  = '#4D3A0B'
let s:base.flexoki_yellow_600  = '#AD8301'
let s:base.flexoki_yellow_400  = '#D0A215'
let s:base.flexoki_yellow_100  = '#FCEEB8'

let s:base.flexoki_green_600   = '#66800B'
let s:base.flexoki_green_400   = '#879A39'

let s:base.flexoki_cyan_950    = '#142625'
let s:base.flexoki_cyan_600    = '#24837B'
let s:base.flexoki_cyan_400    = '#3AA99F'
let s:base.flexoki_cyan_50     = '#EBF2E7'

let s:base.flexoki_blue_600    = '#205EA6'
let s:base.flexoki_blue_400    = '#4385BE'

let s:base.flexoki_purple_600  = '#5E409D'
let s:base.flexoki_purple_400  = '#8B7EC8'

let s:base.flexoki_magenta_600 = '#A02F6F'
let s:base.flexoki_magenta_400 = '#CE5D97'

let s:variants = {}
let s:variants.light = {}
let s:variants.light.bg     = s:base.flexoki_paper
let s:variants.light.bg_2   = s:base.flexoki_50
let s:variants.light.ui     = s:base.flexoki_100
let s:variants.light.ui_2   = s:base.flexoki_150
let s:variants.light.ui_3   = s:base.flexoki_200
let s:variants.light.tx_3   = s:base.flexoki_300
let s:variants.light.tx_2   = s:base.flexoki_600
let s:variants.light.tx     = s:base.flexoki_black
let s:variants.light.re     = s:base.flexoki_red_600
let s:variants.light.re_2   = s:base.flexoki_red_400
let s:variants.light.or     = s:base.flexoki_orange_600
let s:variants.light.or_2   = s:base.flexoki_orange_400
let s:variants.light.ye     = s:base.flexoki_yellow_600
let s:variants.light.ye_2   = s:base.flexoki_yellow_400
let s:variants.light.gr     = s:base.flexoki_green_600
let s:variants.light.gr_2   = s:base.flexoki_green_400
let s:variants.light.cy     = s:base.flexoki_cyan_600
let s:variants.light.cy_2   = s:base.flexoki_cyan_400
let s:variants.light.bl     = s:base.flexoki_blue_600
let s:variants.light.bl_2   = s:base.flexoki_blue_400
let s:variants.light.pu     = s:base.flexoki_purple_600
let s:variants.light.pu_2   = s:base.flexoki_purple_400
let s:variants.light.ma     = s:base.flexoki_magenta_600
let s:variants.light.ma_2   = s:base.flexoki_magenta_400

" xterm-256 approximation of each hex (fallback without termguicolors).
" Doc :help cterm-colors: ctermfg/ctermbg take a number, not a hex.
let s:cterm = {}
let s:cterm['#100F0F'] = '233'
let s:cterm['#FFFCF0'] = '15'
let s:cterm['#1C1B1A'] = '234'
let s:cterm['#282726'] = '235'
let s:cterm['#343331'] = '236'
let s:cterm['#403E3C'] = '237'
let s:cterm['#575653'] = '240'
let s:cterm['#6F6E69'] = '242'
let s:cterm['#878580'] = '102'
let s:cterm['#B7B5AC'] = '249'
let s:cterm['#CECDC3'] = '251'
let s:cterm['#DAD8CE'] = '188'
let s:cterm['#E6E4D9'] = '254'
let s:cterm['#F2F0E5'] = '255'
let s:cterm['#AF3029'] = '130'
let s:cterm['#D14D41'] = '167'
let s:cterm['#BC5215'] = '130'
let s:cterm['#DA702C'] = '166'
let s:cterm['#4D3A0B'] = '58'
let s:cterm['#AD8301'] = '136'
let s:cterm['#D0A215'] = '178'
let s:cterm['#FCEEB8'] = '229'
let s:cterm['#66800B'] = '64'
let s:cterm['#879A39'] = '101'
let s:cterm['#142625'] = '234'
let s:cterm['#24837B'] = '30'
let s:cterm['#3AA99F'] = '73'
let s:cterm['#EBF2E7'] = '255'
let s:cterm['#205EA6'] = '25'
let s:cterm['#4385BE'] = '67'
let s:cterm['#5E409D'] = '61'
let s:cterm['#8B7EC8'] = '104'
let s:cterm['#A02F6F'] = '125'
let s:cterm['#CE5D97'] = '168'

" fix/doc :help highlight: a :hi only replaces the fields given, the
" others are merged with the old ones. The old version only emitted
" guifg/guibg/gui -> 'Statement' kept the bold/cyan from syncolor by default.
" So we always emit the complete set (like desert.vim/habamax.vim).
function! s:Hi(group, opts) abort
  let l:fg  = get(a:opts, 'fg', 'NONE')
  let l:bg  = get(a:opts, 'bg', 'NONE')
  let l:sp  = get(a:opts, 'sp', 'NONE')
  let l:gui = get(a:opts, 'style', 'NONE')
  let l:ctermfg = get(a:opts, 'ctermfg', get(s:cterm, toupper(l:fg), 'NONE'))
  let l:ctermbg = get(a:opts, 'ctermbg', get(s:cterm, toupper(l:bg), 'NONE'))
  " cterm does not know undercurl -> fallback to underline
  let l:cterm = l:gui ==# 'undercurl' ? 'underline' : l:gui
  let l:term  = get(a:opts, 'term', 'NONE')
  execute 'hi ' . a:group
        \ . ' guifg=' . l:fg . ' guibg=' . l:bg . ' guisp=' . l:sp . ' gui=' . l:gui
        \ . ' ctermfg=' . l:ctermfg . ' ctermbg=' . l:ctermbg . ' cterm=' . l:cterm
        \ . ' term=' . l:term
endfunction

" Normal / UI
call s:Hi('Normal',       {'fg': s:variants.light.tx,   'bg': s:variants.light.bg})
call s:Hi('NormalNC',     {'fg': 'NONE',              'bg': 'NONE'})
call s:Hi('Underlined',   {'fg': 'NONE',              'bg': 'NONE', 'style': 'underline'})
call s:Hi('Bold',         {'fg': 'NONE',              'bg': 'NONE', 'style': 'bold'})
call s:Hi('Italic',       {'fg': 'NONE',              'bg': 'NONE', 'style': 'italic'})
call s:Hi('NonText',      {'fg': s:variants.light.tx_3, 'bg': 'NONE'})
call s:Hi('EndOfBuffer',  {'fg': 'NONE', 'bg': 'NONE'})
call s:Hi('Conceal',      {'fg': 'NONE', 'bg': 'NONE'})
call s:Hi('Ignore',       {'fg': 'NONE', 'bg': 'NONE'})

" Spell (faithful to upstream: re-2/ye/gr/pu underlined)
call s:Hi('SpellBad',   {'fg': s:variants.light.re_2, 'bg': 'NONE', 'style': 'underline'})
call s:Hi('SpellCap',   {'fg': s:variants.light.ye,   'bg': 'NONE', 'style': 'underline'})
call s:Hi('SpellLocal', {'fg': s:variants.light.gr,   'bg': 'NONE', 'style': 'underline'})
call s:Hi('SpellRare',  {'fg': s:variants.light.pu,   'bg': 'NONE', 'style': 'underline'})

" Search / Diff (faithful to upstream base.lua)
call s:Hi('Search',       {'fg': s:variants.light.tx, 'bg': s:variants.light.ye})
call s:Hi('IncSearch',    {'fg': s:variants.light.tx, 'bg': s:variants.light.ye})
call s:Hi('CurSearch',    {'fg': s:variants.light.tx, 'bg': s:variants.light.ye_2})
call s:Hi('Substitute',   {'fg': s:variants.light.tx, 'bg': s:variants.light.gr})

call s:Hi('DiffAdd',      {'fg': s:variants.light.bg,   'bg': s:variants.light.gr})
call s:Hi('DiffChange',   {'fg': s:variants.light.bg_2, 'bg': s:variants.light.pu})
call s:Hi('DiffDelete',   {'fg': s:variants.light.bg_2, 'bg': s:variants.light.re})
call s:Hi('DiffText',     {'fg': s:variants.light.bg,   'bg': s:variants.light.bl_2})

" Text / Syntax (flexoki site mapping: tx-3 comments, ye constants,
" cy strings, pu numbers, ma booleans, bl identifiers, or functions, gr keywords)
call s:Hi('Comment',      {'fg': s:variants.light.tx_3, 'bg': 'NONE'})
call s:Hi('Constant',     {'fg': s:variants.light.ye,   'bg': 'NONE'})
call s:Hi('String',       {'fg': s:variants.light.cy,   'bg': 'NONE'})
call s:Hi('Character',    {'fg': s:variants.light.cy,   'bg': 'NONE'})
call s:Hi('Number',       {'fg': s:variants.light.pu,   'bg': 'NONE'})
call s:Hi('Boolean',      {'fg': s:variants.light.ma,   'bg': 'NONE'})
call s:Hi('Float',        {'fg': s:variants.light.pu,   'bg': 'NONE'})

call s:Hi('Identifier',   {'fg': s:variants.light.bl, 'bg': 'NONE'})
call s:Hi('Function',     {'fg': s:variants.light.or, 'bg': 'NONE'})
call s:Hi('Keyword',      {'fg': s:variants.light.gr, 'bg': 'NONE'})
" fix: the original set Statement to NONE/NONE which, through :hi merging, kept
" the default bold. Upstream also sets NONE, but in lua the link is total.
" We link to Keyword like Conditional/Repeat/Label/Exception for consistent rendering.
hi! link Statement Keyword
hi! link Conditional Keyword
hi! link Repeat Keyword
hi! link Label Keyword
hi! link Exception Keyword
call s:Hi('Operator',     {'fg': s:variants.light.tx_2, 'bg': 'NONE'})

call s:Hi('PreProc',      {'fg': s:variants.light.ma, 'bg': 'NONE'})
call s:Hi('Include',      {'fg': s:variants.light.re, 'bg': 'NONE'})
call s:Hi('Define',       {'fg': s:variants.light.ma, 'bg': 'NONE'})
call s:Hi('Macro',        {'fg': s:variants.light.ma, 'bg': 'NONE'})
call s:Hi('PreCondit',    {'fg': s:variants.light.ma, 'bg': 'NONE'})

call s:Hi('Type',          {'fg': s:variants.light.gr, 'bg': 'NONE'})
call s:Hi('StorageClass',  {'fg': s:variants.light.or, 'bg': 'NONE'})
call s:Hi('Structure',     {'fg': s:variants.light.or, 'bg': 'NONE'})
call s:Hi('Typedef',       {'fg': s:variants.light.or, 'bg': 'NONE'})

call s:Hi('SpecialComment', {'fg': s:variants.light.tx,   'bg': 'NONE'})
call s:Hi('Special',        {'fg': s:variants.light.tx_2, 'bg': 'NONE'})
call s:Hi('SpecialChar',    {'fg': s:variants.light.ma,   'bg': 'NONE'})
call s:Hi('Tag',            {'fg': s:variants.light.cy,   'bg': 'NONE'})
call s:Hi('SpecialKey',     {'fg': s:variants.light.bl,   'bg': 'NONE', 'style': 'bold'})
call s:Hi('Debug',          {'fg': s:variants.light.ma,   'bg': 'NONE'})
hi! link Delimiter Special
call s:Hi('Error',          {'fg': s:variants.light.re,   'bg': s:variants.light.bg, 'style': 'bold'})
call s:Hi('Todo',           {'fg': s:variants.light.ma,   'bg': 'NONE', 'style': 'bold'})

" Lines, cursor, visual
call s:Hi('LineNr',        {'fg': s:variants.light.tx_3, 'bg': 'NONE'})
call s:Hi('CursorLineNr',  {'fg': s:variants.light.tx,   'bg': 'NONE', 'style': 'bold'})
call s:Hi('Cursor',        {'fg': s:variants.light.bg,   'bg': s:variants.light.tx})
call s:Hi('lCursor',       {'fg': s:variants.light.bg,   'bg': s:variants.light.tx})
call s:Hi('CursorIM',      {'fg': s:variants.light.bg,   'bg': s:variants.light.tx})
call s:Hi('CursorLine',    {'bg': s:variants.light.ui})
call s:Hi('CursorColumn',  {'bg': s:variants.light.bg_2})
call s:Hi('ColorColumn',   {'bg': s:variants.light.ui})
call s:Hi('Visual',        {'bg': s:variants.light.ui_2})
call s:Hi('VisualNOS',     {'bg': s:variants.light.ui_3})
call s:Hi('MatchParen',    {'bg': s:variants.light.ui})

" UI section missing from the original, completed from upstream base.lua.
" (Without it, StatusLine/Pmenu/etc. fell back to Vim's pink/grey defaults.)
call s:Hi('StatusLine',   {'fg': s:variants.light.tx,   'bg': s:variants.light.ui_3})
call s:Hi('StatusLineNC', {'fg': s:variants.light.tx_2, 'bg': s:variants.light.ui})
call s:Hi('VertSplit',    {'fg': s:variants.light.ui_3, 'bg': 'NONE'})
call s:Hi('WinSeparator', {'fg': s:variants.light.ui_3, 'bg': 'NONE'})
call s:Hi('TabLine',      {'fg': s:variants.light.tx_2, 'bg': s:variants.light.ui})
call s:Hi('TabLineSel',   {'fg': s:variants.light.tx,   'bg': s:variants.light.ui_3})
call s:Hi('TabLineFill',  {'fg': s:variants.light.tx_2, 'bg': s:variants.light.ui})
call s:Hi('Pmenu',        {'fg': s:variants.light.tx_2, 'bg': s:variants.light.bg_2})
call s:Hi('PmenuSel',     {'fg': s:variants.light.tx,   'bg': s:variants.light.cy_2})
call s:Hi('PmenuSbar',    {'bg': s:variants.light.ui})
call s:Hi('PmenuThumb',   {'bg': s:variants.light.ui_3})
call s:Hi('WildMenu',     {'fg': s:variants.light.tx,   'bg': s:variants.light.cy_2})
call s:Hi('Folded',       {'fg': s:variants.light.tx_2, 'bg': s:variants.light.ui})
call s:Hi('FoldColumn',   {'fg': s:variants.light.tx_2, 'bg': 'NONE'})
call s:Hi('SignColumn',   {'fg': 'NONE', 'bg': 'NONE'})
call s:Hi('NormalFloat',  {'fg': s:variants.light.tx_2, 'bg': s:variants.light.bg})
call s:Hi('FloatBorder',  {'fg': s:variants.light.tx_3, 'bg': s:variants.light.bg})
call s:Hi('Title',        {'fg': s:variants.light.bl,   'bg': 'NONE', 'style': 'bold'})
call s:Hi('Directory',    {'fg': s:variants.light.bl,   'bg': 'NONE'})
" fix: the upstream lua references c['orange']/c['blue'] that do not exist (nil).
" We use the real or (600) and bl (600).
call s:Hi('MoreMsg',      {'fg': s:variants.light.or,   'bg': 'NONE'})
call s:Hi('Question',     {'fg': s:variants.light.or,   'bg': 'NONE'})
call s:Hi('ModeMsg',      {'fg': 'NONE', 'bg': s:variants.light.bg_2})
call s:Hi('MsgArea',      {'fg': 'NONE', 'bg': s:variants.light.bg_2})
" fix: upstream WarningMsg in re on bg, we keep it (deliberate upstream).
call s:Hi('WarningMsg',   {'fg': s:variants.light.re,   'bg': s:variants.light.bg})
call s:Hi('ErrorMsg',     {'fg': s:variants.light.re_2, 'bg': 'NONE', 'style': 'bold'})
" fix: QuickFixLine pointed to c['ui2_blue'] which does not exist (nil). Fallback to ui_2.
call s:Hi('QuickFixLine', {'bg': s:variants.light.ui_2})
call s:Hi('Whitespace',   {'fg': s:variants.light.tx_3, 'bg': 'NONE'})

" Diagnostic / Git
call s:Hi('DiagnosticError', {'fg': s:variants.light.re})
call s:Hi('DiagnosticWarn',  {'fg': s:variants.light.ye})
call s:Hi('DiagnosticInfo',  {'fg': s:variants.light.cy})
call s:Hi('DiagnosticHint',  {'fg': s:variants.light.bl})
call s:Hi('DiagnosticOk',    {'fg': s:variants.light.gr})

call s:Hi('Added',   {'fg': s:variants.light.gr})
call s:Hi('Removed', {'fg': s:variants.light.re})
call s:Hi('Changed', {'fg': s:variants.light.or})
