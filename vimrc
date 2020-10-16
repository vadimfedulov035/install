call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'rafi/awesome-vim-colorschemes'
Plug 'jiangmiao/auto-pairs'
Plug 'airblade/vim-gitgutter'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
call plug#end()

syntax on

set tabstop=4
set shiftwidth=4

set number relativenumber
set nu rnu

set hlsearch
set incsearch

colorscheme nord
let g:airline_theme='cobalt2'

map <C-n> :NERDTreeToggle<CR>
map <C-p> :CtrlP<CR>
