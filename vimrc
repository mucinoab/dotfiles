"map<c-j> :w <CR> :!g++ "%" -Wall -pedantic -std=c++11 -g -OE<CR><CR>:q <CR>
map<c-h> :w <CR> :!g++ "%" -Wall -pedantic -std=c++11 -g -O2<CR>:!sleep 1<CR>:q <CR>

nmap j gj
nmap k gk
nmap n o<Esc>
inoremap jk <esc>
syntax on

set mouse=a
set clipboard=unnamedplus
set shiftwidth=2
set tabstop=2
set virtualedit=all
set encoding=utf-8
set laststatus=0
set scrolloff=5
set undofile
set cursorline
set number
set autoindent
set smarttab
set smartindent
set ruler   
set title
set showcmd
set autoread
set shiftround
set expandtab
set lazyredraw
set relativenumber

"cosas para editar texto simple, no código
filetype plugin indent on
au BufRead,BufNewFile *.txt,*.tex set wrap linebreak nolist textwidth=0 wrapmargin=0 formatoptions=l lbr nocul
let g:latex_indent_enabled = 1
let g:latex_fold_envs = 0
let g:latex_fold_sections = []

set spell
set spelllang=es,en
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u   

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
Plug 'justinmk/vim-sneak'
Plug 'rust-lang/rust.vim'
Plug 'Yggdroot/indentLine'
Plug 'psliwka/vim-smoothie'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'dense-analysis/ale'
" List ends here. Plugins become visible to Vim after this call.
call plug#end()

let g:ale_linters_explicit = 1
let g:ale_completion_enabled = 1
let g:ale_linters = {'tex':['texlab', 'writegood'], 'markdown':['writegood']}

"tema polarized"tema polarized
colorscheme solarized8_flat
let &t_8f = "\<ESC>[38;2;%Lu;%Lu;%loom"
let &t_8b = "\<ESC>[48;2;%Lu;%Lu;%loom"
let g:solarized_termtrans = 1
let g:solarized_visibility = "low"
set background=dark

hi clear Spell Bad
hi SpellBad cterm=underline  ctermfg=Red

"desactiva las flecha
nnoremap <up> <nop>
nnoremap <right> <nop>
nnoremap <left> <nop>
nnoremap <down> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

"ctr j-k para mover lineas completas
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

" Quick-save y salir con C-espacio 
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

set redrawtime=10000
set updatetime=500
set shortmess+=c
set signcolumn=yes

"para que los wild menus acepten con enter
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<CR>"

"indent Line
let g:indentLine_char ='┊'

 " Jump to last edit position on opening file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g`\"" | endif
endif  
