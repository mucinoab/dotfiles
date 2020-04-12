"map<c-j> :w <CR> :!g++ "%" -Wall -pedantic -std=c++11 -g -O2<CR><CR>:q <CR>
map<c-h> :w <CR> :!g++ "%" -Wall -pedantic -std=c++11 -g -O2<CR>:!sleep 1<CR>:q <CR>

inoremap jk <esc>
syntax on
set clipboard=unnamedplus
set undofile
set cursorline
set number
set mouse=a
set autoindent
set shiftwidth=2
set smarttab
set smartindent
set ruler   
set title
set tabstop=2
set showcmd
set autoread
set shiftround
set expandtab
set lazyredraw
set encoding=utf-8
set laststatus=0
set scrolloff=5
set relativenumber

highlight LineNr ctermfg=grey

set spell
set spelllang=es,en

function! My_Tab_Completion()
    if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
        return "\<C-P>"
    else
        return "\<Tab>"
endfunction
inoremap <Tab> <C-R>=My_Tab_Completion()<CR>

autocmd FileType cpp let b:comment_leader = '// '
autocmd FileType rs let b:comment_leader = '// '
autocmd FileType python let b:comment_leader = '# '
noremap <silent> ,c :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:nohlsearch<CR>
noremap <silent> ,u :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:nohlsearch<CR>

" Jump to start and end of line using the home row keys
map H ^
map L $

"vim plug 

" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')
Plug 'lifepillar/vim-solarized8'
Plug 'tpope/vim-surround'
Plug 'rust-lang/rust.vim'
Plug 'justinmk/vim-sneak'
Plug 'dense-analysis/ale'
" List ends here. Plugins become visible to Vim after this call.
call plug#end()

let g:ale_linters_explicit = 1
let g:ale_linters = {
\   'latex': ['redpen'],
\}

"tema solarized"tema solarized
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
let g:solarized_termtrans = 1
set background=dark
set t_Co=256
let base16colorspace=256

"desactiva las flecha
nnoremap <up> <nop>
nnoremap <right> <nop>
nnoremap <left> <nop>
nnoremap <down> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

"ctrl j-k para mover lineas completas
function! s:swap_lines(n1, n2)
    let line1 = getline(a:n1)
    let line2 = getline(a:n2)
    call setline(a:n1, line2)
    call setline(a:n2, line1)
endfunction


function! s:swap_up()
    let n = line('.')
    if n == 1
        return
    endif

    call s:swap_lines(n, n - 1)
    exec n - 1
endfunction

function! s:swap_down()
    let n = line('.')
    if n == line('$')
        return
    endif

    call s:swap_lines(n, n + 1)
    exec n + 1
endfunction

noremap <silent> <c-k> :call <SID>swap_up()<CR>
noremap <silent> <c-j> :call <SID>swap_down()<CR>

" Quick-save y salir  con espacio 
let mapleader = "\<Space>"
nmap <leader>w :w<CR>
nmap <leader>q :q<CR>
nmap <C-Space> :wq<CR>
imap <C-Space> <Esc>:wq<CR>

" Proper search
set incsearch
set ignorecase
set smartcase
set gdefault

" Jump to last edit position on opening file
if has("autocmd")
  au BufReadPost * if expand('%:p') !~# '\m/\.git/' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

hi clear SpellBad
hi SpellBad cterm=underline  ctermfg=Red
