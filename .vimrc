set nocompatible

if !has('nvim') && has('mouse')
  set mouse=a
endif

set number
set ruler
set backspace=indent,eol,start
set autoindent
set expandtab
set tabstop=4
set smarttab
set showcmd
set shiftwidth=4
set softtabstop=4
set ttyfast                   " we have a fast terminal
set noerrorbells              " No error bells please
filetype on                   " Enable filetype detection
filetype indent on            " Enable filetype-specific indenting
filetype plugin on            " Enable filetype-specific plugins
set wildmenu                  " menu has tab completion
set wildmode=longest:full
syntax enable
set background=dark
set incsearch                 " incremental search
set hlsearch                  " highlight last searched pattern
set background=dark
set clipboard^=unnamed,unnamedplus " https://stackoverflow.com/a/30691754

" Space -> Page Down
map <Space> <PageDown>
" S-Enter - insert a new line above and get back to normal mode

" Use ctrl-[hjkl] to select the active split!
nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>


" comment line, selection with Ctrl-N,Ctrl-N
au BufEnter *.py nnoremap  <C-N><C-N>    mn:s/^\(\s*\)#*\(.*\)/\1#\2/ge<CR>:noh<CR>`n
au BufEnter *.py inoremap  <C-N><C-N>    <C-O>mn<C-O>:s/^\(\s*\)#*\(.*\)/\1#\2/ge<CR><C-O>:noh<CR><C-O>`n
au BufEnter *.py vnoremap  <C-N><C-N>    mn:s/^\(\s*\)#*\(.*\)/\1#\2/ge<CR>:noh<CR>gv`n

" uncomment line, selection with Ctrl-N,N
au BufEnter *.py nnoremap  <C-N>n     mn:s/^\(\s*\)#\([^ ]\)/\1\2/ge<CR>:s/^#$//ge<CR>:noh<CR>`n
au BufEnter *.py inoremap  <C-N>n     <C-O>mn<C-O>:s/^\(\s*\)#\([^ ]\)/\1\2/ge<CR><C-O>:s/^#$//ge<CR><C-O>:noh<CR><C-O>`n
au BufEnter *.py vnoremap  <C-N>n     mn:s/^\(\s*\)#\([^ ]\)/\1\2/ge<CR>gv:s/#\n/\r/ge<CR>:noh<CR>gv`n
