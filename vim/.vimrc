" Static Interface Elements
syntax on
set term=screen-256color
set number
set relativenumber
set laststatus=2
set scrolloff=4

" I/O Behavior
set mouse=nvi
set backspace=indent,eol,start

" Dynamic Interaction Elements
set tabstop=2 shiftwidth=2 expandtab smarttab autoindent
set showmatch
set hlsearch incsearch
set linebreak "breakindent
set novisualbell noerrorbells

" Powerline
set rtp+=$USER_SITE/powerline/bindings/vim
python3 from powerline.vim import setup as powerline_setup
python3 powerline_setup()
python3 del powerline_setup
