vim.g.did_load_filetypes = 1

--- completion stuff
-- https://github.com/hrsh7th/nvim-cmp/issues/156#issuecomment-916338617
-- Custom comparators based on a given priority
local lspkind_comparator = function(conf)
  local lsp_types = require('cmp.types').lsp
  return function(entry1, entry2)
    if entry1.source.name ~= 'nvim_lsp' then
      if entry2.source.name == 'nvim_lsp' then
        return false
      else
        return nil
      end
    end
    local kind1 = lsp_types.CompletionItemKind[entry1:get_kind()]
    local kind2 = lsp_types.CompletionItemKind[entry2:get_kind()]

    local priority1 = conf.kind_priority[kind1] or 0
    local priority2 = conf.kind_priority[kind2] or 0
    if priority1 == priority2 then
      return nil
    end
    return priority2 < priority1
  end
end

-- Lexicographical order (?)
local label_comparator = function(entry1, entry2)
  return entry1.completion_item.label < entry2.completion_item.label
end

local kind_icons = {
  Text = "",
  Method = "",
  Function = "",
  Constructor = "",
  Field = "",
  Variable = "",
  Class = "ﴯ",
  Interface = "",
  Module = "",
  Property = "ﰠ",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = ""
}

local cmp = require 'cmp'
cmp.setup {
  mapping = {
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
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
    { name = 'buffer', options = { keyword_pattern = [[\k\+]] } },
    { name = 'path' },
    { name = 'treesitter' },
  },
  sorting = {
    comparators = {
      require "cmp-under-comparator".under,
      lspkind_comparator({
        kind_priority = {
          Field = 11,
          Property = 11,
          Method = 11,
          Constant = 10,
          Enum = 10,
          EnumMember = 10,
          Event = 10,
          Function = 10,
          Operator = 10,
          Reference = 10,
          Struct = 10,
          Variable = 10,
          File = 8,
          Folder = 8,
          Class = 5,
          Color = 5,
          Module = 5,
          Keyword = 2,
          Constructor = 1,
          Interface = 1,
          Text = 1,
          TypeParameter = 1,
          Unit = 1,
          Value = 1,
          Snippet = -1,
        },
      }),
      label_comparator,
    },
  },
  formatting = {
    format = function(_, vim_item)
      vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
      return vim_item
    end
  },
}


-- Treesitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = {"rust", "python", "typescript", "cpp", "html", "latex", "go", "c_sharp", "markdown"},
  highlight = { enable = true, additional_vim_regex_highlighting = false },
  indent = { enable = true },
  refactor = { highlight_definitions = { enable = true }, },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<CR>',
      scope_incremental = '<CR>',
      node_incremental = '<TAB>',
      node_decremental = '<S-TAB>',
    }
  }
}

-- nvim_lsp object
local nvim_lsp = require'lspconfig'

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- TypeScript
nvim_lsp.tsserver.setup {capabilities = capabilities,}

-- Julia
nvim_lsp.julials.setup {capabilities = capabilities,}

-- Vue
nvim_lsp.vuels.setup{}

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
local omnisharp_bin = "/home/mucinoab/Downloads/omnisharp/run"
nvim_lsp.omnisharp.setup{
  cmd = { omnisharp_bin, "--languageserver" , "--hostPID", tostring(pid) },
  capabilities = capabilities,
}

-- telescope
local actions = require('telescope.actions')

require('telescope').setup{
  defaults = {
    layout_config = {
      horizontal = { preview_width = 90 }
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
  clickable = true,
  semantic_letters = false,
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
  cursor_scrolls_alone = true,
})

local t = {}
t['<C-u>'] = {'scroll', {'-vim.wo.scroll', 'true', '100'}}
t['<C-d>'] = {'scroll', { 'vim.wo.scroll', 'true', '100'}}

require('neoscroll.config').set_mappings(t)

require("indent_blankline").setup { char = "┊" }
require'hop'.setup()

--- LSP keymaps
local opts = { noremap=true, silent=true }
vim.api.nvim_set_keymap('n', 'grr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)

require('Comment').setup()
require "lsp_signature".setup()
require('gitsigns').setup {
  signcolumn = false,
  numhl      = true,
  watch_gitdir = { interval = 15000, follow_files = true },
  update_debounce = 100,
  max_file_length = 4000,
}
