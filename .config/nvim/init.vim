:set number
:set relativenumber
:set autoindent
:set tabstop=4
:set shiftwidth=4
:set smarttab
:set softtabstop=4
:set mouse=a

call plug#begin('~/.config/nvim/plugged')

Plug 'https://github.com/itchyny/lightline.vim'		" Lightline statusbar
Plug 'https://github.com/preservim/nerdtree'		" Nerd Tree (Filesystem tree)
Plug 'https://github.com/neoclide/coc.nvim'			" Autocompletion

call plug#end()

let NERDTreeShowHidden=1

let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ }

inoremap <expr> <Tab> pumvisible() ? coc#_select_confirm() : "<Tab>"
