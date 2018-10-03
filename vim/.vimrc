syntax on
set number
set relativenumber
set tabstop=2 shiftwidth=2 expandtab
set laststatus=2
set showmatch
set hlsearch
set backspace=indent,eol,start
set autoindent

python3 from powerline.vim import setup as powerline_setup
python3 powerline_setup()
python3 del powerline_setup
let g:airline_powerline_fonts = 1
