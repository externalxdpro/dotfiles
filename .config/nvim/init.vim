:set number
:set relativenumber
:set autoindent
:set tabstop=4
:set shiftwidth=4
:set smarttab
:set softtabstop=4
:set mouse=a

call plug#begin()

Plug 'https://github.com/vim-airline/vim-airline'
Plug 'https://github.com/preservim/nerdtree'
Plug 'https://github.com/neoclide/coc.nvim'

call plug#end()

let NERDTreeShowHidden=1

let g:airline_powerline_fonts=1

inoremap <expr> <Tab> pumvisible() ? coc#_select_confirm() : "<Tab>"
