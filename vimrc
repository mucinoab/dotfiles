"map<c-j> :w <CR> :!g++ "%" -Wall -pedantic -std=c++11 -g -OE<CR><CR>:q <CR>
map<c-h> :w <CR> :!g++ "%" -Wall -pedantic -std=c++11 -g -O2<CR>:!sleep 1<CR>:q <CR>
nmap j gj
nmap k gk
nmap <c-n> o<Esc>
inoremap jk <esc>
syntax on

set hidden
set synmaxcol=350
set mouse=a
set clipboard=unnamedplus
set shiftwidth=2
set tabstop=2
"set virtualedit=all
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
set expandtab
set shiftround
set lazyredraw
set relativenumber

"cosas para editar texto simple, no código
filetype plugin indent on
au BufRead,BufNewFile *.txt,*.tex,*.md set wrap linebreak nolist tw=80 wrapmargin=0 formatoptions=l lbr fo+=b
let g:latex_indent_enabled = 1
let g:tex_flavor = "latex"

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

autocmd FileType cpp,rust let b:comment_leader = '// '
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
Plug 'edkolev/tmuxline.vim'
Plug 'tpope/vim-surround'
Plug 'justinmk/vim-sneak'
"Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
Plug 'psliwka/vim-smoothie'
Plug 'SirVer/ultisnips'
Plug 'Yggdroot/indentLine'
Plug 'rust-lang/rust.vim'
Plug 'airblade/vim-rooter'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" List ends here. Plugins become visible to Vim after this call.
call plug#end()

let g:LanguageClient_serverCommands = {
    \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
    \ 'python': ['/usr/local/bin/pyls'],
    \ 'tex': ['/home/bruno/.cargo/bin/texlab'],
    \ 'latex': ['/home/bruno/.cargo/bin/texlab'],
    \ }
let g:UltiSnipsSnippetDirectories=[$HOME.'/dotfiles/snips']
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'

"let g:ale_linters_explicit = 1
"let g:ale_completion_enabled = 1
"let g:ale_linters = {'tex':['texlab', 'writegood'], 'markdown':['writegood']}
 
let g:tmuxline_preset = 'minimal'
let g:tmuxline_theme = {
    \   'a'    : [ 236, 236 ],
    \   'b'    : [ 253, 239 ],
    \   'c'    : [ 244, 236 ],
    \   'x'    : [ 244, 236 ],
    \   'y'    : [ 253, 239 ],
    \   'z'    : [ 236, 102 ],
    \   'win'  : [ 102, 236 ],
    \   'cwin' : [ 236, 102 ],
    \   'bg'   : [ 244, 236 ],}


"tema polarized"tema polarized
colorscheme solarized8_flat
let &t_8f = "\<ESC>[38;2;%Lu;%Lu;%loom"
let &t_8b = "\<ESC>[48;2;%Lu;%Lu;%loom"

hi clear Spell Bad
hi SpellBad cterm=underline  ctermfg=Red

"desactiva las flecha
nnoremap <right> <nop>
nnoremap <up> <nop>
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
nmap <C-Space> :call CloseIfEmpty()<CR>
imap <C-Space> <Esc>:call CloseIfEmpty()<CR> 
nmap <leader>t :ene <CR> :file new<CR>
nmap <leader><leader> <c-^>
map <leader><Tab> :bn<CR>
nmap <leader>b :Buffers<CR>
nmap <leader>f :Files<CR>
tnoremap <leader><leader> <C-\><C-n><c-^>     

"cierra buffer actual y solo lo guarda si no esta vacio. 
"tmabien cierra vim si solo queda un buffer y es vacio:wq
fu! CloseIfEmpty()
  exec 'w' 
  exec 'bd'
  if line('$') == 1 && getline(1) == ''
      exec 'q'
      exec '<CR>'
  endif
endfu

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

" <leader>s for RC search, busca en directorio actual, en los contenidos de
" los archivos
noremap <leader>s :Rg<CR>
let g:fzf_layout = { 'down': '~15%' }
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

function! s:list_cmd()
  let base = fnamemodify(expand('%'), ':h:.:S')
  return base == '.' ? 'fd --type file --follow' : printf('fd --type file --follow | proximity-sort %s', shellescape(expand('%')))
endfunction
"Busa en tus archivos
command! -bang -nargs=? -complete=dir Files
     \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': ['--info=inline']}), <bang>0)
