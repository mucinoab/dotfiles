require('impatient')
require('lsp-format').setup {}

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

local cmp = require('cmp')
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
      require('luasnip').lsp_expand(args.body)
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
      require("cmp-under-comparator").under,
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
          Variable = 12,
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
require('nvim-treesitter.configs').setup {
  ensure_installed = {"rust", "python", "javascript", "typescript", "cpp", "html", "latex", "go", "markdown", "json", "java", "c" , "svelte"},
  highlight = { enable = true, additional_vim_regex_highlighting = false, disable = { "c_sharp" } },
  indent = { enable = true },
  refactor = {
    highlight_definitions = { enable = true },
    smart_rename = {
      enable = true,
      keymaps = {
        smart_rename = "grr",
      },
    },
  },
}

-- nvim_lsp object
local nvim_lsp = require('lspconfig')

-- Disable Semantic Highlighting
-- https://old.reddit.com/r/neovim/comments/12gvms4/this_is_why_your_higlights_look_different_in_90/
for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do vim.api.nvim_set_hl(0, group, {}) end 

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
capabilities.textDocument.completion.completionItem.snippetSupport = true

local on_attach = function(client)
  require("lsp-format").on_attach(client)
  -- Disable code highlight by the LSP server
  client.server_capabilities.semanticTokensProvider = nil 
end

-- TypeScript
nvim_lsp.tsserver.setup {capabilities = capabilities, on_attach=on_attach,}

-- Svelte
nvim_lsp.svelte.setup {capabilities = capabilities, on_attach=on_attach,}

-- CPP
nvim_lsp.clangd.setup {capabilities = capabilities, on_attach=on_attach,}

-- HTML
nvim_lsp.html.setup {capabilities = capabilities } --, on_attach=on_attach,}

-- Python
nvim_lsp.pyright.setup{capabilities = capabilities, on_attach=on_attach,}

-- CSS
nvim_lsp.cssls.setup {capabilities = capabilities, on_attach=on_attach,}

-- Enable rust_analyzer
-- https://sharksforarms.dev/posts/neovim-rust/
nvim_lsp.rust_analyzer.setup({
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = {
        extraArgs={"--target-dir", "/tmp/rust-analyzer-check"}
      },
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
  on_attach = on_attach,
})

-- Enable diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = true,
  signs = false,
  update_in_insert = false,
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
  on_attach = on_attach,
}

-- C#
local pid = vim.fn.getpid()
local omnisharp_bin = "/home/mucinoab/Downloads/omnisharp/OmniSharp"
nvim_lsp.omnisharp.setup{
  cmd = { omnisharp_bin, "--languageserver" , "--hostPID", tostring(pid) },
  capabilities = capabilities,
  on_attach = on_attach,
}

-- telescope
local actions = require('telescope.actions')

require('telescope').setup{
  defaults = {
    layout_config = {
      horizontal = { preview_width = 95 }
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
   -- path_display = { 'shorten' },
    winblend = 15,
    mappings = { i = { ["<esc>"] = actions.close } },
    set_env = { ['COLORTERM'] = 'truecolor' },
  },
}

require('telescope').load_extension('fzy_native')

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
require('barbar').setup {
  icons = { filetype = { enabled = false } },
  insert_at_end = true,
  clickable = true,
  semantic_letters = false,
  tabpages = false,
  auto_hide = true,
  animation = false,
}

-- GPS
-- local gps = require("nvim-gps")
-- gps.setup()

require('lualine').setup ({
  options = { icons_enabled = false, theme = 'wombat', },
  sections = {
    lualine_b = {'filename'},
--    lualine_c = {{ gps.get_location, condition = gps.is_available }},
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
require('Comment').setup()
require "lsp_signature".setup()
require('gitsigns').setup {
  signcolumn = false,
  numhl      = true,
  watch_gitdir = { interval = 15000, follow_files = true },
  update_debounce = 100,
  max_file_length = 4000,
}

require("scrollbar").setup({
  show = true,
  handle = {
    text = " ",
    color = "gray",
    hide_if_all_visible = true,
  },
  marks = {
    Search = { text = { "--", "==" }, priority = 0, color = "orange" },
    Error = { text = { "--", "==" }, priority = 1, color = "red" },
    Warn = { text = { "--", "==" }, priority = 2, color = "yellow" },
    Info = { text = { "--", "==" }, priority = 3, color = "blue" },
    Hint = { text = { "--", "==" }, priority = 4, color = "green" },
    Misc = { text = { "--", "==" }, priority = 5, color = "purple" },
  },
  excluded_filetypes = {
    "",
    "prompt",
    "TelescopePrompt",
  },
  autocmd = {
    render = {
      "BufWinEnter",
      "TabEnter",
      "TermEnter",
      "WinEnter",
      "CmdwinLeave",
      "TextChanged",
      "VimResized",
      "WinScrolled",
    },
  },
  handlers = {
    diagnostic = true,
    search = false,
  },
})

require"fidget".setup{}

-- Different Cursorline depending on the mode
require('modes').setup({
  colors = {
    delete = "#c75c6a",
    insert = "#78ccc5",
    visual = "#f5c359",
  },
  line_opacity = 0.1,
  set_cursor = true,
  focus_only = false
})

vim.cmd('hi ModesDelete guibg=#c75c6a')
vim.cmd('hi ModesInsert guibg=#78ccc5')
vim.cmd('hi ModesVisual guibg=#9745be')
