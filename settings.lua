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

-- Vue JS
require'lspconfig'.vuels.setup{}

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

vim.g.bufferline = {
  insert_at_end = true,
  icons = false,
  closable = false,
  tabpages = false,
  auto_hide = true,
  animation = false,
}

-- GPS 
local gps = require("nvim-gps")
gps.setup({
	languages = {
		["c"] = true,
		["cpp"] = true,
		["go"] = true,
		["javascript"] = true,
		["typescript"] = true,
		["python"] = true,
		["rust"] = true,
	},
})

require('lualine').setup ({
  options = { icons_enabled = false, theme = 'wombat', },
  sections = {
    lualine_b = {'filename'},
    lualine_c = {{ gps.get_location, condition = gps.is_available }},
    lualine_x = {'encoding', 'filetype'},
  },
})
