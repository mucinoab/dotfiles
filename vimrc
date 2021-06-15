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
"set relativenumber
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
"set signcolumn=yes

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
au BufRead,BufNewFile *.txt,*.tex,*.latex,*.md set wrap linebreak nolist tw=80 wrapmargin=0 formatoptions=l lbr fo+=b nornu nonumber
"au BufWrite *.tex,*.latex,*.cpp,*.rs :Autoformat
"au BufWrite *.tex,*.latex,*.cpp,*.ts,*.go,*.by :Autoformat

let g:latex_indent_enabled = 1

set spell
set spelllang=es,en
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u<Esc>ha

"tera templates -> html
autocmd BufNewFile,BufRead *.tera set syntax=html
autocmd BufNewFile,BufRead *.tera set ft=html

autocmd FileType cpp,rust,htlm,js,typescript,go let b:comment_leader = '// '
autocmd FileType python,julia let b:comment_leader = '# '
autocmd FileType tex let b:comment_leader = '% '
noremap <silent> ,c :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:nohlsearch<CR>
noremap <silent> ,u :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:nohlsearch<CR>

" Jump to start and end of line using the home row keys
map H ^
map L $

"vim plug
call plug#begin('~/.vim/plugged')
Plug 'itchyny/lightline.vim'
Plug 'lifepillar/vim-solarized8'
Plug 'edkolev/tmuxline.vim'
Plug 'tpope/vim-surround'
Plug 'SirVer/ultisnips', { 'for': ['tex', 'latex'] }
Plug 'lervag/vimtex', { 'for': ['tex', 'latex']}
Plug 'Yggdroot/indentLine', { 'for': ['cpp', 'python', 'rust', 'go', 'julia', 'html', 'javascript'] }
Plug 'rust-lang/rust.vim', { 'for': 'rust'}
Plug 'airblade/vim-rooter'
Plug 'Chiel92/vim-autoformat'
"Plug 'sbdchd/neoformat'
Plug 'preservim/nerdtree'
Plug 'luochen1990/rainbow'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'chaoren/vim-wordmotion'

Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'nvim-lua/completion-nvim'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-telescope/telescope.nvim'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
call plug#end()

augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank({timeout = 350})
augroup END

augroup fmt
  autocmd!
  autocmd BufWritePre *.tex,*.latex,*.cpp,*.ts,*.go,*.py Autoformat
augroup END

"tema polarized"tema polarized
let &t_8f = "\<ESC>[38;2;%Lu;%Lu;%loom"
let &t_8b = "\<ESC>[48;2;%Lu;%Lu;%loom"
colorscheme solarized8
"colorscheme moonlight
let g:solarized_extra_hi_groups=1


lua <<EOF
-- nvim_lsp object
local nvim_lsp = require'lspconfig'

require'nvim-treesitter.configs'.setup {
  ensure_installed = {"rust", "python", "typescript", "cpp", "html", "latex"},
  highlight = { enable = true },
  indent = { enable = true }
}

-- TypeScript
nvim_lsp.tsserver.setup {}

-- HTML
require'lspconfig'.html.setup{}

-- Python
require'lspconfig'.pyright.setup{}

-- function to attach completion when setting up lsp
local on_attach = function(client)
    require'completion'.on_attach(client)
end

-- Enable rust_analyzer
-- https://sharksforarms.dev/posts/neovim-rust/
nvim_lsp.rust_analyzer.setup({
    on_attach=on_attach,
    settings = {
        ["rust-analyzer"] = {
            cargo = { loadOutDirsFromCheck = true },
            procMacro = { enable = false },
            diagnostics = {
                enable = true,
                disabled = {"unresolved-proc-macro"},
                enableExperimental = true,
            },
        }
    }
})

-- Enable diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    signs = true,
    update_in_insert = true,
  }
)


-- golang
lspconfig = require "lspconfig"
  lspconfig.gopls.setup {
    cmd = {"gopls", "serve"},
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
          nilness = true,
          simplifyrange = true,
          unusedwrite = true,
        },
        staticcheck = true,
      },
    },
  }

-- Key bindings
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

--buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
end

-- telescope 
local actions = require('telescope.actions')

require('telescope').setup{ 
  defaults = { 
    winblend = 5,
    mappings = { i = { ["<esc>"] = actions.close } },
    set_env = { ['COLORTERM'] = 'truecolor' },
  },
}
EOF

" Enable type inlay hints
autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *
\ lua require'lsp_extensions'.inlay_hints{ prefix = '', highlight = "Comment", enabled = {"TypeHint", "ChainingHint", "ParameterHint"} }
let g:completition_matching_strategy_list = ['exact', 'substring', 'fuzzy']

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Goto previous/next diagnostic warning/error
nnoremap <silent> g{ <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> g} <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <space>a <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <space>e <cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>

" use <Tab> as trigger keys
imap <Tab> <Plug>(completion_smart_tab)
imap <S-Tab> <Plug>(completion_smart_s_tab)

"parentesis de colores
let g:rainbow_active = 1

"lightline 
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'filename': 'LightlineFilename',
      \   'cocstatus': 'coc#status'
      \ },
      \ }

let g:lightline#bufferline#shorten_path = 0
let g:lightline#bufferline#show_number = 0
let g:lightline#bufferline#unnamed = '[No Name]'

let g:lightline.tabline          = {'left': [['buffers']], 'right': [['']]}
let g:lightline.component_expand = {'buffers': 'lightline#bufferline#buffers'}
let g:lightline.component_type   = {'buffers': 'tabsel'}
"let g:lightline#bufferline#auto_hide = 12000
let g:lightline#bufferline#min_buffer_count = 3
let g:lightline.component_raw = {'buffers': 1}
let g:lightline#bufferline#clickable = 1

"hace el lightline del mismo color
let s:palette = g:lightline#colorscheme#{g:lightline.colorscheme}#palette
let s:palette.normal.middle = [ [ 'NONE', 'NONE', 'NONE', 'NONE' ] ]
let s:palette.inactive.middle = s:palette.normal.middle
let s:palette.tabline.middle = s:palette.normal.middle

function! LightlineFilename()
  return expand('%:t') !=# '' ? @% : '[No Name]'
endfunction

"rainbow 
let g:rainbow_conf = {'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],}

"nerd tree
map <C-t> :NERDTreeToggle<CR>
filetype plugin indent on
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
autocmd BufEnter * if bufname('#') =~# "^NERD_tree_" && winnr('$') > 1 | b# | endif
let g:plug_window = 'noautocmd vertical topleft new'

let g:NERDTreeDirArrowExpandable = ''
let g:NERDTreeDirArrowCollapsible = ''

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
nmap <leader>t :ene <CR> :file new<CR>

"navegar entre buffers.
map <leader><Tab> :bn<CR>
map <leader><S-Tab> :bp<CR>
nmap <leader><leader> <c-^>
tnoremap <leader><leader> <C-\><C-n><c-^>

"telescope find f-ile, s-earch, b-uffer
nmap <leader>f <cmd>Telescope find_files theme=get_dropdown<cr>
nmap <leader>s <cmd>Telescope live_grep theme=get_dropdown<cr>
nmap <leader>b <cmd>Telescope buffers theme=get_dropdown<cr>
nmap <leader>gs <cmd>Telescope git_status<cr>
nmap <leader>ld <cmd>Telescope lsp_workspace_diagnostics<cr>
highlight TelescopeSelectionCaret guifg=#ff3333
highlight TelescopeSelection      guifg=#D79921 gui=bold,underline
highlight TelescopePreviewLine    guifg=#D79921 gui=underline
highlight TelescopePreviewNormal  guibg=#222222
highlight TelescopeNormal         guibg=#222222

"cierra buffer actual y solo lo guarda si no esta vacío.
"también cierra vim si solo queda un buffer y esta vacío:wq
fu! CloseIfEmpty()
  exec 'w'
  exec 'bd'
  if line('$') == 1 && getline(1) == ''
    exec 'q'
  endif
endfu

"indent Line
let g:indentLine_char ='┊'

" Jump to last edit position on opening file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
        \| exe "normal! g`\"" | endif
endif

if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
