vmap j gj
vmap k gk
nmap j gj
nmap k gk
nmap <c-n> o<Esc>
map q: :q
map Q <Nop>
inoremap jk <esc>
syntax on
set hidden
set synmaxcol=350
set mouse=a
set clipboard=unnamedplus
set shiftwidth=2
set tabstop=2
set nohlsearch
"set virtual edit=all
set encoding=utf-8
set laststatus=2
set noshowmode
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
set termguicolors

" Proper search
set incsearch
set ignorecase
set smartcase
set gdefault

set redrawtime=10000
set updatetime=500
set shortmess+=c
"set signcolumn=yes

"cosas para editar texto simple, no código
filetype plugin indent on
autocmd BufRead *.tex,*.latex set filetype=tex
au BufRead,BufNewFile *.txt,*.tex,*.latex,*.md set wrap linebreak nolist tw=80 wrapmargin=0 formatoptions=l lbr fo+=b nornu nonumber
au BufWrite *.tex,*.latex :Autoformat

let g:latex_indent_enabled = 1

set spell
set spelllang=es,en
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u<Esc>ha

autocmd FileType cpp,rust let b:comment_leader = '// '
autocmd FileType python let b:comment_leader = '# '
autocmd FileType tex let b:comment_leader = '% '
noremap <silent> ,c :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:nohlsearch<CR>
noremap <silent> ,u :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:nohlsearch<CR>

" Jump to start and end of line using the home row keys
map H ^
map L $

"vim plug
" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')
Plug 'neoclide/coc.nvim', { 'for': ['cpp', 'python', 'rust', 'rs', 'py'], 'branch': 'release'}
Plug 'itchyny/lightline.vim'
Plug 'lifepillar/vim-solarized8'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'edkolev/tmuxline.vim'
Plug 'tpope/vim-surround'
Plug 'justinmk/vim-sneak'
Plug 'psliwka/vim-smoothie'
Plug 'SirVer/ultisnips', { 'for': ['tex', 'latex'] }
Plug 'lervag/vimtex', { 'for': ['tex', 'latex']}
Plug 'Yggdroot/indentLine', { 'for': ['cpp', 'python', 'rust', 'go'] }
Plug 'rust-lang/rust.vim', { 'for': 'rust'}
Plug 'airblade/vim-rooter'
Plug 'machakann/vim-highlightedyank'
Plug 'Chiel92/vim-autoformat'
Plug 'preservim/nerdtree'
Plug 'luochen1990/rainbow'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
"Plug 'KeitaNakamura/tex-conceal.vim', { 'for': ['tex', 'latex'] }
"Plug 'jalvesaq/Nvim-R', {'branch': 'stable'}
"Plug 'edkolev/tmuxline.vim'
"Plug 'godlygeek/tabular'
call plug#end()

"parentesis de colores
let g:rainbow_active = 1

"lightline 

let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'filename': 'LightlineFilename',
      \   'cocstatus': 'coc#status'
      \ },
      \ }

function! LightlineFilename()
  return expand('%:t') !=# '' ? @% : '[No Name]'
endfunction

autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

"rainbow 
let g:rainbow_conf = {'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold', 'start=/</ end=/>/ fold'],}

"nerd tree
map <C-t> :NERDTreeToggle<CR>
filetype plugin indent on
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
autocmd BufEnter * if bufname('#') =~# "^NERD_tree_" && winnr('$') > 1 | b# | endif
let g:plug_window = 'noautocmd vertical topleft new'

let g:NERDTreeDirArrowExpandable = ''
let g:NERDTreeDirArrowCollapsible = ''

"highlightedyank
let g:highlightedyank_highlight_duration = 350

"Rustfmt on save
let g:rustfmt_autosave = 1
let g:rustfmt_emit_files = 1
let g:rustfmt_fail_silently = 1
let g:vimtex_format_enabled=1
let g:vimtex_fold_manual=1
let g:vimtex_compiler_latexmk = {'build_dir' : 'build',}
let g:vimtex_compiler_progname = 'nvr'
let g:tex_flavor='latex'
let g:vimtex_quickfix_mode=0
let g:vimtex_view_method='zathura'
set conceallevel=0
let g:tex_conceal='abdmg'
let g:UltiSnipsSnippetDirectories=['/home/bruno/Dotfiles/snips']
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'


"No avisos rojos
let g:LanguageClient_useVirtualText = 0

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
let &t_8f = "\<ESC>[38;2;%Lu;%Lu;%loom"
let &t_8b = "\<ESC>[48;2;%Lu;%Lu;%loom"
"colorscheme solarized8_flat
colorscheme solarized8
let g:solarized_extra_hi_groups=1
"colorscheme iceberg

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

"navegar entre buffers.
map <leader><Tab> :bn<CR>
map <leader><S-Tab> :bp<CR>
nmap <leader>f :Files<CR>
nmap <leader>b :Buffers<CR>
nmap <leader><leader> <c-^>
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

"para que los wild menus acepten con enter
"inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<CR>"

"indent Line
let g:indentLine_char ='┊'

" Jump to last edit position on opening file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
        \| exe "normal! g`\"" | endif
endif

inoremap <silent><expr> <tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction


"set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

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
