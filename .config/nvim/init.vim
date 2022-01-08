call plug#begin('~/.config/nvim/plugged')

Plug 'https://github.com/itchyny/lightline.vim'		" Lightline statusbar
Plug 'https://github.com/preservim/nerdtree'		" Nerd Tree (Filesystem tree)
Plug 'https://github.com/neoclide/coc.nvim'			" Autocompletion

call plug#end()

set number						" Display line numbers
set relativenumber				" Show line numbers relative to current line
set expandtab					" Use spaces instead of tabs
set autoindent
set tabstop=4					" One tab = four spaces
set shiftwidth=4				" One tab = four spaces
set softtabstop=4				" One tab = four spaces
set smarttab
set mouse=a						" Enable mouse functionality
set clipboard=unnamedplus       " Copy/paste between vim and other programs.

let NERDTreeShowHidden=1		"Show hidden files and directories in Nerd Tree
" Set lightline theme
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ }

inoremap <expr> <Tab> pumvisible() ? coc#_select_confirm() : "<Tab>"
