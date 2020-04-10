"map<c-j> :w <CR> :!g++ "%" -Wall -pedantic -std=c++11 -g -O2<CR><CR>:q <CR>

map<c-h> :w <CR> :!g++ "%" -Wall -pedantic -std=c++11 -g -O2<CR>:!sleep 1<CR>:q <CR>
set clipboard=unnamedplus
inoremap jk <esc>
syntax on
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
" Start scrolling three lines before the horizontal window border
set scrolloff=5

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
nnoremap B ^
nnoremap E $
"-----------------------------------------------------------------------------------------
"vim plug 

" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

" Declare the list of plugins.
Plug 'lifepillar/vim-solarized8'
Plug 'tpope/vim-surround'
Plug 'rust-lang/rust.vim'
" List ends here. Plugins become visible to Vim after this call.
call plug#end()

"tema solarized"tema solarized
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
let g:solarized_termtrans = 1
set background=dark
"colorscheme solarized8
set t_Co=256

set undofile
nnoremap <up> <nop>
nnoremap <right> <nop>
nnoremap <left> <nop>
nnoremap <down> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
set lazyredraw
set encoding=utf-8
set laststatus=0


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
