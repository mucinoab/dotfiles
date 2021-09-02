vmap j gj
vmap k gk
nmap j gj
nmap k gk
nmap <c-n> o<Esc>
map q: :q
map Q <Nop>
inoremap jk <esc>

"borrar palabra completa 
noremap! <C-BS> <C-w>
noremap! <C-h> <C-w>

nnoremap Y y$

"exit con Q
:command Q q

" mantienen el cursor en el centro al iterar en búsquedas
nnoremap n nzzzv
nnoremap N Nzzzv

"control j-k para mover lineas y selecciones completas
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==
inoremap <C-k> <Esc>:m .-2<CR>==gi
inoremap <C-j> <Esc>:m .+1<CR>==gi
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv

"moverte entre splits
map <C-h> <C-W>h
map <C-l> <C-W>l

syntax on
set relativenumber
set hidden
set synmaxcol=400
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
set showmatch
set autoread
set expandtab
set shiftround
set lazyredraw
set termguicolors
set showtabline=2

" Proper search
set incsearch
set ignorecase
set smartcase
set gdefault

set redrawtime=10000
set updatetime=100
set shortmess+=c

" Wrapping options
set formatoptions=tc " wrap text and comments using textwidth
set formatoptions+=r " continue comments when pressing ENTER in I mode
set formatoptions+=q " enable formatting of comments with gq
set formatoptions+=n " detect lists for formatting
set formatoptions+=b " auto-wrap in insert mode, and do not wrap old long lines

set completeopt=menuone,noinsert,noselect

" Prevent accidental writes to buffers that shouldn't be edited
autocmd BufRead *.orig set readonly
autocmd BufRead *.pacnew set readonly

"cosas para editar texto simple, no código
filetype plugin indent on
autocmd BufRead *.tex,*.latex set filetype=tex
au BufRead,BufNewFile *.txt,*.tex,*.latex,*.md set wrap linebreak nolist tw=79 wrapmargin=0 lbr fo=tro nonumber nornu

let g:latex_indent_enabled = 1

set spell
set spelllang=es,en
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u<Esc>ha

" tera templates -> html
autocmd BufNewFile,BufRead *.tera set syntax=html
autocmd BufNewFile,BufRead *.tera set ft=html

" blade templates -> html
autocmd BufNewFile,BufRead *.blade.php set syntax=html
autocmd BufNewFile,BufRead *.blade.php set ft=html

" comentar líneas
autocmd FileType cpp,rust,htlm,js,typescript,go,cs,php let b:comment_leader = '// '
autocmd FileType python,julia let b:comment_leader = '# '
autocmd FileType tex let b:comment_leader = '% '
noremap <silent> ,c :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:nohlsearch<CR>
noremap <silent> ,u :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:nohlsearch<CR>

" Jump to start and end of line using the home row keys
map H g^
map L g$

"vim plug
call plug#begin('~/.vim/plugged')
Plug 'lewis6991/impatient.nvim'
Plug 'mhartington/oceanic-next'
"Plug 'edkolev/tmuxline.vim'
Plug 'SirVer/ultisnips', { 'for': ['tex', 'latex'] }
Plug 'lervag/vimtex', { 'for': ['tex', 'latex']}
Plug 'Yggdroot/indentLine', { 'for': ['cpp', 'python', 'rust', 'go', 'julia', 'html', 'javascript', 'php', 'blade', 'typescript'] }
Plug 'ojroques/nvim-bufdel'
Plug 'airblade/vim-rooter'
Plug 'Chiel92/vim-autoformat'
Plug 'romgrk/barbar.nvim'
Plug 'chaoren/vim-wordmotion'

Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'l3mon4d3/luasnip'

Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'saadparwaiz1/cmp_luasnip'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
"nvim-telescope/telescope-project.nvim

Plug 'nvim-treesitter/nvim-treesitter', { 'branch': '0.5-compat', 'do': ':TSUpdate' }

Plug 'rmagatti/auto-session'
Plug 'rmagatti/session-lens'

Plug 'hoob3rt/lualine.nvim'
Plug 'SmiteshP/nvim-gps'

Plug 'karb94/neoscroll.nvim'
call plug#end()

augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank({timeout = 350})
augroup END

augroup fmt
  autocmd!
  autocmd BufWritePre *.tex,*.latex,*.cpp,*.ts,*.go,*.py,*.rs,*.cs Autoformat
augroup END

colorscheme OceanicNext
let g:oceanic_next_terminal_bold = 1
let g:oceanic_next_terminal_italic = 1

lua <<EOF
require('settings')
EOF

" Enable type inlay hints
autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *
\ lua require'lsp_extensions'.inlay_hints{ prefix = '', highlight = "Comment", enabled = {"TypeHint", "ChainingHint", "ParameterHint"} }

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Goto previous/next diagnostic warning/error
nnoremap <silent> g{ <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> g} <cmd>lua vim.lsp.diagnostic.goto_next()<CR>

nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <leader> k <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <space>a <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <space>e <cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>

let g:vimtex_format_enabled=1
let g:vimtex_fold_manual=1
let g:vimtex_compiler_latexmk = {'build_dir' : 'build',}
let g:vimtex_compiler_progname = 'nvr'
let g:tex_flavor='latex'
let g:vimtex_quickfix_mode=0
let g:vimtex_view_method='zathura'
set conceallevel=0
let g:tex_conceal="abdgm"
let g:UltiSnipsSnippetDirectories=['/home/bruno/Dotfiles/snips']
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'

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

" Quick-save y salir con C-espacio
let mapleader = "\<Space>"
nmap <leader>w :w<CR>
nmap <C-Space> :call CloseIfEmpty()<CR>
imap <C-Space> <Esc>:call CloseIfEmpty()<CR>
"nmap <leader>t :ene <CR> :file new<CR>

"navegar entre buffers.
map <leader><Tab> :BufferNext<CR>
map <leader><S-Tab> :BufferPrevious<CR>
nmap <leader><leader> <c-^>
tnoremap <leader><leader> <C-\><C-n><c-^>

"telescope find f-ile, s-earch, b-uffer, g-it s-tatus, h-istory
nmap <leader>f  <cmd>Telescope find_files<cr>
nmap <leader>s  <cmd>Telescope live_grep<cr>
nmap <Leader>b  <cmd>lua require'telescope.builtin'.buffers(require('telescope.themes').get_dropdown({}))<cr>
nmap <leader>gs <cmd>Telescope git_status<cr>
nmap <leader>ld <cmd>Telescope lsp_workspace_diagnostics<cr>
nmap <leader>h  <cmd>Telescope command_history<cr>
nmap <leader>p  <cmd>Telescope session-lens search_session<cr>
highlight TelescopeSelectionCaret guifg=#ff3333
highlight TelescopeSelection      guifg=#D79921 gui=bold,underline
highlight TelescopePreviewLine    guifg=#D79921 gui=underline

"cierra buffer actual y solo lo guarda si no esta vacío.
"también cierra vim si solo queda un buffer y esta vacío:wq
fu! CloseIfEmpty()
  exec 'w'
  let nbuffers = len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))
  if nbuffers == 1
    exec 'BufDel'
  else 
    exec 'BufferClose'
  endif
endfu

"indent Line
let g:indentLine_char ='┊'

" Jump to last edit position on opening file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
        \| exe "normal! g`\"" | endif
endif

" nvim built in file viewer   
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25

" Toggle Vexplore with Ctrl-T
map <silent> <C-T> :Lexplore!<CR>
