--- completion stuff

local cmp = require 'cmp'
cmp.setup {
  mapping = {
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    })
  },
  snippet = {
    expand = function(args)
      require'luasnip'.lsp_expand(args.body)
    end
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
    --{ name = 'treesitter' },
  }
}


-- Treesitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = {"rust", "python", "typescript", "cpp", "html", "latex"},
  highlight = { enable = true },
  indent = { enable = true }
}

-- nvim_lsp object
local nvim_lsp = require'lspconfig'

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- TypeScript
nvim_lsp.tsserver.setup {capabilities = capabilities,}

-- CPP
nvim_lsp.clangd.setup {capabilities = capabilities,}

-- HTML
nvim_lsp.html.setup {capabilities = capabilities,}

-- Python
nvim_lsp.pyright.setup{capabilities = capabilities,}

-- PHP
nvim_lsp.phpactor.setup{capabilities = capabilities,}

-- CSS
nvim_lsp.cssls.setup {capabilities = capabilities,}

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
nvim_lsp.gopls.setup {
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
  capabilities = capabilities,
}

-- C#
local pid = vim.fn.getpid()
local omnisharp_bin = "/home/bruno/Downloads/omnisharp/OmniSharp.exe"
nvim_lsp.omnisharp.setup{
  cmd = { omnisharp_bin, "--languageserver" , "--hostPID", tostring(pid) },
  capabilities = capabilities,
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
  log_level = 'error',
  auto_session_enable_last_session = false,
  auto_session_root_dir = vim.fn.stdpath('data').."/sessions/",
  auto_session_enabled = true,
  auto_save_enabled = false,
  auto_restore_enabled = false,
  auto_session_suppress_dirs = nil
}
require('auto-session').setup(opts)

-- various
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

require('neoscroll').setup({
  stop_eof = false,
  use_local_scrolloff = false,
  respect_scrolloff = false,
  cursor_scrolls_alone = false,
})

local t = {}
t['<C-u>'] = {'scroll', {'-vim.wo.scroll', 'true', '100'}}
t['<C-d>'] = {'scroll', { 'vim.wo.scroll', 'true', '100'}}

require('neoscroll.config').set_mappings(t)

require("indent_blankline").setup { char = "┊" }
