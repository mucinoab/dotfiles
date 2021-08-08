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
au BufRead,BufNewFile *.txt,*.tex,*.latex,*.md set wrap linebreak nolist tw=79 wrapmargin=0 formatoptions=l lbr fo+=b nornu nonumber

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
Plug 'mhartington/oceanic-next'
Plug 'itchyny/lightline.vim'
Plug 'edkolev/tmuxline.vim'
Plug 'SirVer/ultisnips', { 'for': ['tex', 'latex'] }
Plug 'lervag/vimtex', { 'for': ['tex', 'latex']}
Plug 'Yggdroot/indentLine', { 'for': ['cpp', 'python', 'rust', 'go', 'julia', 'html', 'javascript', 'php', 'blade', 'typescript'] }
Plug 'ojroques/nvim-bufdel'
Plug 'airblade/vim-rooter'
Plug 'Chiel92/vim-autoformat'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'chaoren/vim-wordmotion'

Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'hrsh7th/nvim-compe'
Plug 'l3mon4d3/luasnip'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'

Plug 'nvim-treesitter/nvim-treesitter', { 'branch': '0.5-compat', 'do': ':TSUpdate' }

Plug 'rmagatti/auto-session'
Plug 'rmagatti/session-lens'
call plug#end()

augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank({timeout = 350})
augroup END

augroup fmt
  autocmd!
  autocmd BufWritePre *.tex,*.latex,*.cpp,*.ts,*.go,*.py,*rs,*cs Autoformat
augroup END

"tema polarized"tema polarized
let &t_8f = "\<ESC>[38;2;%Lu;%Lu;%loom"
let &t_8b = "\<ESC>[48;2;%Lu;%Lu;%loom"
colorscheme OceanicNext
let g:oceanic_next_terminal_bold = 1
let g:oceanic_next_terminal_italic = 1

"colorscheme solarized8
"colorscheme solarized
let g:solarized_extra_hi_groups=1

lua <<EOF
-- nvim_lsp object
local nvim_lsp = require'lspconfig'

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  }
}

require'nvim-treesitter.configs'.setup {
  ensure_installed = {"rust", "python", "typescript", "cpp", "html", "latex"},
  highlight = { enable = true },
  indent = { enable = true }
}

-- TypeScript
nvim_lsp.tsserver.setup {}

-- CPP
require'lspconfig'.clangd.setup{}

-- HTML
require'lspconfig'.html.setup {}

-- Python
require'lspconfig'.pyright.setup{}

-- PHP
require'lspconfig'.phpactor.setup{}

-- CSS
local css_capabilities = vim.lsp.protocol.make_client_capabilities()
css_capabilities.textDocument.completion.completionItem.snippetSupport = true

require'lspconfig'.cssls.setup {
  css_capabilities = capabilities,
}

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
    },
    capabilities = capabilities,
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

-- C#
local pid = vim.fn.getpid()
local omnisharp_bin = "/home/bruno/Downloads/omnisharp/OmniSharp.exe"
require'lspconfig'.omnisharp.setup{
    cmd = { omnisharp_bin, "--languageserver" , "--hostPID", tostring(pid) };
}

-- telescope 
local actions = require('telescope.actions')

require('telescope').setup{ 
  defaults = { 
   layout_config = {
      horizontal = { preview_width = 0.60 }
    },
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case'
    },
    path_display = { 'shorten' },
    winblend = 15,
    mappings = { i = { ["<esc>"] = actions.close } },
    set_env = { ['COLORTERM'] = 'truecolor' },
  },
}

require('telescope').load_extension('fzy_native')
require("telescope").load_extension("session-lens")

-- Auto Session
local opts = {
  log_level = 'info',
  auto_session_enable_last_session = false,
  auto_session_root_dir = vim.fn.stdpath('data').."/sessions/",
  auto_session_enabled = true,
  auto_save_enabled = false,
  auto_restore_enabled = nil,
  auto_session_suppress_dirs = nil
}
require('auto-session').setup(opts)

-- completion stuff 
require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  resolve_timeout = 800;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = {
    border = { '', '' ,'', ' ', '', '', '', ' ' }, -- the border option is the same as `|help nvim_open_win|`
    winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
    max_width = 120,
    min_width = 60,
    max_height = math.floor(vim.o.lines * 0.3),
    min_height = 1,
  };
  source = {
    path = true;
    buffer = true;
    nvim_lsp = true;
    nvim_lua = true;
    ultisnips = false;
    luasnip = true;  
    treesitter = true;
  };
}
EOF

inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-w> compe#complete()

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
let g:lightline#bufferline#min_buffer_count = 2
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
map <leader><Tab> :bn<CR>
map <leader><S-Tab> :bp<CR>
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
  exec 'BufDel'
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
let g:netrw_winsize = 15

" Toggle Vexplore with Ctrl-T
function! ToggleVExplorer()
  if exists("t:expl_buf_num")
      let expl_win_num = bufwinnr(t:expl_buf_num)
      if expl_win_num != -1
          let cur_win_nr = winnr()
          exec expl_win_num . 'wincmd w'
          close
          exec cur_win_nr . 'wincmd w'
          unlet t:expl_buf_num
      else
          unlet t:expl_buf_num
      endif
  else
      exec '1wincmd w'
      Vexplore
      let t:expl_buf_num = bufnr("%")
  endif
endfunction

map <silent> <C-T> :call ToggleVExplorer()<CR>
