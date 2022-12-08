"scriptencoding utf-8
"set encoding=utf-8
set tabstop=2 noexpandtab
set number relativenumber
set backspace=indent,eol,start
set hlsearch incsearch
set scrolloff=8 " scroll before being on last line
set signcolumn=number

" Set colors for whitespace
set listchars=tab:>>,trail:<,extends:>,precedes:<,space:·
set list
hi SpecialKey ctermfg=darkgrey guifg=darkgrey

" Used by OmniSharp
let g:OmniSharp_server_use_net6 = 1
let g:OmniSharp_highlight_types = 2
let g:ale_linters = { 'cs': ['OmniSharp'] }

" VIM Plug (autocheck if installed)
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
	silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
Plug 'OmniSharp/omnisharp-vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install()} }
Plug 'junegunn/fzf.vim'
Plug 'dense-analysis/ale'
Plug 'lambdalisue/fern.vim'
Plug 'prabirshrestha/asyncomplete.vim'
call plug#end()

:map <C-p> :Files<CR>
:map <C-S-i> :OmniSharpCodeFormat<CR>
:map <C-S-e> :Fern . -drawer -toggle -reveal=%<CR> " File explorer

