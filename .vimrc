set nocompatible

" Vundle
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'vim-syntastic/syntastic'
Plugin 'kien/ctrlp.vim'
Plugin 'davidhalter/jedi-vim' 
Plugin 'ervandew/supertab'
Plugin 'udalov/kotlin-vim'
Plugin 'racer-rust/vim-racer'
Plugin 'lervag/vimtex'
Plugin 'danilo-augusto/vim-afterglow'

call vundle#end()
filetype plugin indent on

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_python_checkers=['pylint', 'python']
let g:syntastic_python_pylint_args = "--disable=R,C,W0611"
let g:syntastic_cpp_clang_args="-std=c++17"
let g:syntastic_rust_checkers=['cargo']

let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_prompt_mappings = {
    \ 'AcceptSelection("e")': ['<2-LeftMouse>'],
    \ 'AcceptSelection("t")': ['<cr>'],
    \ }

autocmd FileType python setlocal completeopt-=preview
autocmd FileType rust call SuperTabSetDefaultCompletionType("<c-x><c-o>")

let g:racer_experimental_completer = 1
let g:racer_insert_paren = 1

au FileType rust nmap gd <Plug>(rust-def)
au FileType rust nmap gs <Plug>(rust-def-split)
au FileType rust nmap gx <Plug>(rust-def-vertical)
au FileType rust nmap <leader>gd <Plug>(rust-doc)
" End plugin setup


if has('mouse')
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
"set path+='**'

colorscheme afterglow
if has("gui_running")
       set guifont=Monaco
       " colorscheme default
endif

" Space -> Page Down
map <Space> <PageDown>
" S-Enter - insert a new line above and get back to normal mode
nmap <S-Enter> O<Esc>
" Enter - insert a new line below and get back to normal mode

" Keybindings to compile-run or interpret
autocmd filetype haskell nnoremap <F9> :w <bar> exec '!runhaskell '.shellescape('%')<CR>
autocmd filetype python nnoremap <F9> :w <bar> exec '!python '.shellescape('%')<CR>
autocmd filetype c nnoremap <F9> :w <bar> exec '!gcc '.shellescape('%').' -o '.shellescape('%:r').' && ./'.shellescape('%:r')<CR>
autocmd filetype cpp nnoremap <F9> :w <bar> exec '!g++ -Wall -std=c++17 '.shellescape('%').' -o '.shellescape('%:r').' && ./'.shellescape('%:r')<CR>
"autocmd filetype rust nnoremap <F9> :w <bar> exec '!rustc '.shellescape('%').' && ./'.shellescape('%:r')<CR>
autocmd filetype rust nnoremap <F9> :w <bar> exec '!cargo run'<CR>
autocmd filetype rust nnoremap <F10> :w <bar> exec '!cargo check'<CR>

" comment line, selection with Ctrl-N,Ctrl-N
au BufEnter *.py nnoremap  <C-N><C-N>    mn:s/^\(\s*\)#*\(.*\)/\1#\2/ge<CR>:noh<CR>`n
au BufEnter *.py inoremap  <C-N><C-N>    <C-O>mn<C-O>:s/^\(\s*\)#*\(.*\)/\1#\2/ge<CR><C-O>:noh<CR><C-O>`n
au BufEnter *.py vnoremap  <C-N><C-N>    mn:s/^\(\s*\)#*\(.*\)/\1#\2/ge<CR>:noh<CR>gv`n

" uncomment line, selection with Ctrl-N,N
au BufEnter *.py nnoremap  <C-N>n     mn:s/^\(\s*\)#\([^ ]\)/\1\2/ge<CR>:s/^#$//ge<CR>:noh<CR>`n
au BufEnter *.py inoremap  <C-N>n     <C-O>mn<C-O>:s/^\(\s*\)#\([^ ]\)/\1\2/ge<CR><C-O>:s/^#$//ge<CR><C-O>:noh<CR><C-O>`n
au BufEnter *.py vnoremap  <C-N>n     mn:s/^\(\s*\)#\([^ ]\)/\1\2/ge<CR>gv:s/#\n/\r/ge<CR>:noh<CR>gv`n
