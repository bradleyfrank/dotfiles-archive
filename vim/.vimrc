""
"" Static Interface Elements
""
let g:airline_theme='bubblegum'
syntax on

set term=screen-256color
set laststatus=2
set scrolloff=4

" use hybrid line numbering by default with automatic toggling
set number relativenumber
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END


""
"" I/O Behavior
""
set mouse=i
set backspace=indent,eol,start
set ttimeoutlen=10


""
"" Dynamic Interaction Elements
""
set tabstop=2 shiftwidth=2 expandtab smarttab autoindent
set showmatch
set hlsearch incsearch
set linebreak
set novisualbell noerrorbells
