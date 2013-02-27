color darkblue
set nocompatible
set columns=120
set number

set encoding=utf-8
set fileencoding=chinese
set fileencodings=ucs-bom,utf-8,chinese
set ambiwidth=double

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set backspace=2

set showmatch
set nohls
set hlsearch
set incsearch

setlocal omnifunc=javacomplete#Complete
setlocal completefunc=javacomplete#CompleteParamsInfo
inoremap <buffer> <C-X><C-U> <C-X><C-U><C-P> 
inoremap <buffer> <C-S-Space> <C-X><C-U><C-P>
filetype on
filetype indent on
filetype plugin on
filetype plugin indent on
set iskeyword+=_,$,@,%,#,-
syntax enable
syntax on
autocmd FileType java set omnifunc=javacomplete#Complete

set nocindent
set autoindent
set smartindent
autocmd FileType cpp,c,java,sh,pl,php,asp set autoindent
autocmd FileType cpp,c,java,sh,pl,php,asp set smartindent
