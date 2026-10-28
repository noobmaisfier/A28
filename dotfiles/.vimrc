" Copy in visual mode: select + copy to wl-copy
xnoremap <silent> y y:call system('wl-copy', @")<CR>

" Copy a line with yy and send it to wl-copy
nnoremap <silent> yy yy:call system('wl-copy', @")<CR>

" Paste from the system clipboard with "+p
nnoremap <silent> "+p :let @"=substitute(system('wl-paste --no-newline'), '\r', '', 'g')<CR>p

" Paste from the primary clipboard with "*p
nnoremap <silent> "*p :let @"=substitute(system('wl-paste --no-newline --primary'), '\r', '', 'g')<CR>p


set clipboard=unnamed,unnamedplus
set nocompatible
set termguicolors
"set t_Co=256

syntax on           " Enable syntax highlighting
filetype on         " Enable file type detection
filetype plugin on  " Enable file type specific plugins
filetype indent on  " Enable file type specific indentation

cmap w!! w !sudo tee > /dev/null %


" Enable syntax highlighting
syntax on

" Enable line numbers
"set number

" Highlight search matches
" set hlsearch

" Ignore case when searching
set ignorecase
set smartcase

" Search as you type
set incsearch

" Keep smart indentation
set autoindent
set smartindent

" Use spaces instead of tabs
set expandtab
set tabstop=4
set shiftwidth=4

" Keep a margin of lines around the cursor
set scrolloff=5

" Enable mouse mode
set mouse=a

" Automatically save before quitting or switching buffers
"autocmd BufLeave * silent! write

" Enable the enhanced status bar
"set laststatus=2

" Show matching lines between ( ) { }
set showmatch



call plug#begin()
Plug 'catppuccin/vim', { 'as': 'catppuccin' }
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && pnpm install' }
Plug 'preservim/nerdtree'
" Auto-completion
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/goyo.vim'
Plug 'liuchengxu/vim-which-key'

call plug#end()

" ~/.vimrc
source ~/.vim/mappings.vim


" Launch NERDTree with F2
map <F2> :NERDTreeToggle<CR>

" Automatically enable Goyo when Vim starts
" autocmd VimEnter * Goyo


inoremap jj <Esc>

" default rice theme: catppuccin mocha
set background=dark
colorscheme catppuccin_mocha
"colorscheme flexoki_light

nnoremap ; :

" 6. Automatically enable which-key on leader
let mapleader = " "
nnoremap <silent> <leader> :WhichKey '<Space>'<CR>


" NERDTree mappings
nnoremap <silent> <leader>n :NERDTreeToggle<CR>       " Open/close NERDTree
nnoremap <silent> <leader>f :NERDTreeFind<CR>         " Find the current file in NERDTree

" Toggle between the NERDTree window and the active editing window
function! ToggleNERDTreeWindow()
  " Check whether NERDTree is open
  if exists("t:NERDTreeBufName")
    " If we are in NERDTree, go to the previous window (editor)
    if &filetype ==# 'nerdtree'
      wincmd p
    else
      " Otherwise, find the NERDTree window and move to it
      exec "NERDTreeFocus"
    endif
  else
    echo "NERDTree is not open"
  endif
endfunction

nnoremap <silent> <leader>e :call ToggleNERDTreeWindow()<CR>



