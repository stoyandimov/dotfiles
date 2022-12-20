" Commands: {{{
scriptencoding utf-8
highlight SpecialKey ctermfg=darkgrey guifg=darkgrey
"}}}

" Settings: {{{
set encoding=utf-8
set tabstop=2
set shiftwidth=2
set noexpandtab
set number
set relativenumber
set backspace=indent,eol,start
set hlsearch
set incsearch
set scrolloff=8
set signcolumn=number
set listchars=tab:>\ ,trail:<,extends:>,precedes:<,space:·
set list
"}}}

" VimPlug: {{{
if empty(glob('~/.vim/autoload/plug.vim'))
	silent execute '!curl -fLo ~/.vim/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
Plug 'junegunn/fzf', { 'do': { -> fzf#install()} }
Plug 'junegunn/fzf.vim'
call plug#end()
"}}}

" Mappings: {{{
:map <C-p> :Files<CR>
"}}}
