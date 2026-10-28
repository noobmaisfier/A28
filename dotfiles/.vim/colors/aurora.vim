" Aurora for Vim - NO EXISTING PORT, built by hand.
" Aurora shell palette (~/.iCode/kumizo/examples/aurora/src/theme.rs,
" "Aurora" entry, GREEN accent #00E8C6). Fixed 2026-10-10: replaces
" the old purple aurora.vim (ray-x). Requires termguicolors.
" vim:fileencoding=utf-8

if exists('g:colors_name')
  finish
endif
let g:colors_name='aurora'

set background=dark
hi clear
if exists('syntax_on')
  syntax reset
endif

let s:bg      = '#0B0E14'
let s:bg2     = '#131824'
let s:raised  = '#1C2333'
let s:border  = '#232B40'
let s:fg      = '#E6EDF7'
let s:muted   = '#6B7794'
let s:accent  = '#00E8C6'
let s:accent2 = '#8B7CFF'
let s:ok      = '#4ADE80'
let s:warn    = '#FBBF24'
let s:danger  = '#FF5C7A'

exe 'hi Normal guifg='.s:fg 'guibg='.s:bg
exe 'hi Comment guifg='.s:muted 'gui=italic'
exe 'hi Constant guifg='.s:ok
exe 'hi String guifg='.s:ok
exe 'hi Character guifg='.s:ok
exe 'hi Number guifg='.s:warn
exe 'hi Boolean guifg='.s:warn
exe 'hi Float guifg='.s:warn
exe 'hi Identifier guifg='.s:accent
exe 'hi Function guifg='.s:accent
exe 'hi Statement guifg='.s:accent2 'gui=bold'
exe 'hi Conditional guifg='.s:accent2
exe 'hi Repeat guifg='.s:accent2
exe 'hi Operator guifg='.s:fg
exe 'hi Keyword guifg='.s:accent2
exe 'hi Exception guifg='.s:danger
exe 'hi PreProc guifg='.s:accent
exe 'hi Type guifg='.s:accent 'gui=bold'
exe 'hi StorageClass guifg='.s:accent2
exe 'hi Structure guifg='.s:accent
exe 'hi Typedef guifg='.s:accent
exe 'hi Special guifg='.s:warn
exe 'hi SpecialComment guifg='.s:muted 'gui=italic'
exe 'hi Error guifg='.s:danger 'guibg='.s:bg2 'gui=bold'
exe 'hi Todo guifg='.s:warn 'guibg='.s:bg2 'gui=bold'

exe 'hi Cursor guifg='.s:bg 'guibg='.s:accent
exe 'hi CursorLine guibg='.s:bg2 'gui=NONE'
exe 'hi CursorLineNr guifg='.s:accent 'gui=bold'
exe 'hi LineNr guifg='.s:muted
exe 'hi Visual guibg='.s:raised
exe 'hi Search guifg='.s:bg 'guibg='.s:warn
exe 'hi IncSearch guifg='.s:bg 'guibg='.s:accent
exe 'hi MatchParen guifg='.s:accent 'gui=bold'

exe 'hi StatusLine guifg='.s:fg 'guibg='.s:raised
exe 'hi StatusLineNC guifg='.s:muted 'guibg='.s:bg2
exe 'hi VertSplit guifg='.s:border
exe 'hi Pmenu guifg='.s:fg 'guibg='.s:raised
exe 'hi PmenuSel guifg='.s:bg 'guibg='.s:accent
exe 'hi PmenuSbar guibg='.s:bg2
exe 'hi PmenuThumb guibg='.s:border
exe 'hi TabLine guifg='.s:muted 'guibg='.s:bg2
exe 'hi TabLineSel guifg='.s:fg 'guibg='.s:raised 'gui=bold'
exe 'hi TabLineFill guibg='.s:bg

exe 'hi DiffAdd guifg='.s:ok 'guibg='.s:bg2
exe 'hi DiffChange guifg='.s:warn 'guibg='.s:bg2
exe 'hi DiffDelete guifg='.s:danger 'guibg='.s:bg2
exe 'hi DiffText guifg='.s:warn 'guibg='.s:raised 'gui=bold'
exe 'hi GitGutterAdd guifg='.s:ok
exe 'hi GitGutterChange guifg='.s:warn
exe 'hi GitGutterDelete guifg='.s:danger
exe 'hi DiagnosticError guifg='.s:danger
exe 'hi DiagnosticWarn guifg='.s:warn
exe 'hi DiagnosticInfo guifg='.s:accent2
exe 'hi DiagnosticHint guifg='.s:muted

if has('terminal')
  let g:terminal_ansi_colors = [
    \ '#232B40', '#FF5C7A', '#4ADE80', '#FBBF24',
    \ '#8B7CFF', '#E879F9', '#00E8C6', '#A8B6D1',
    \ '#475569', '#FDA4AF', '#86EFAC', '#FCD34D',
    \ '#A5B4FC', '#F0ABFC', '#5EEAD4', '#E6EDF7' ]
endif
