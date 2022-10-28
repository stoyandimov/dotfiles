scriptencoding utf-8
set encoding=utf-8

set tabstop=2 noexpandtab
set number
filetype off
syntax on
filetype plugin indent on
set backspace=indent,eol,start
set hlsearch
set relativenumber

" Set colors for whitespace
set listchars=tab:>>,trail:<,extends:>,precedes:<,space:·
set list
hi SpecialKey ctermfg=darkgrey guifg=darkgrey

" Used by OmniSharp
filetype indent plugin on
let g:OmniSharp_highlight_types = 2
let g:ale_linters = {
\ 'cs': ['OmniSharp']
\}
