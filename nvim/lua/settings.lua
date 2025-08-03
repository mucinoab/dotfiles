vim.loader.enable()

vim.opt.redrawtime = 10000
vim.opt.updatetime = 100

-- Enable syntax highlighting
vim.cmd('syntax on')

vim.opt.hidden = true
vim.opt.synmaxcol = 800
vim.opt.clipboard = 'unnamedplus'
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.hlsearch = false
vim.opt.encoding = 'utf-8'
vim.opt.laststatus = 2
vim.opt.showmode = false
vim.opt.scrolloff = 1000
vim.opt.undofile = true
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.autoindent = true
vim.opt.smarttab = true
vim.opt.smartindent = true
vim.opt.ruler = true
vim.opt.title = true
vim.opt.showcmd = true
vim.opt.showmatch = true
vim.opt.autoread = true
vim.opt.expandtab = true
vim.opt.shiftround = true
vim.opt.lazyredraw = true
vim.opt.termguicolors = true
vim.opt.showtabline = 2
vim.opt.colorcolumn = '99999'

-- Proper search settings
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.gdefault = true

vim.opt.spell = true
vim.opt.spelllang = { 'es', 'en' }

vim.opt.wildmode = "longest,full"

vim.opt.shortmess:append('c')

-- Set format options
vim.opt.formatoptions = 'tc'      -- wrap text and comments using textwidth
vim.opt.formatoptions:append('r') -- continue comments when pressing ENTER in Insert mode
vim.opt.formatoptions:append('q') -- enable formatting of comments with gq
vim.opt.formatoptions:append('n') -- detect lists for formatting
vim.opt.formatoptions:append('b') -- auto-wrap in insert mode, and do not wrap old long lines

-- Set complete options
vim.opt.completeopt = { 'menuone', 'noinsert', 'noselect' }


-- Prevent accidental writes to buffers that shouldn't be edited
vim.api.nvim_create_autocmd("BufRead", { pattern = "*.orig", command = "set readonly" })
vim.api.nvim_create_autocmd("BufRead", { pattern = "*.pacnew", command = "set readonly" })

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1


-- Enable filetype plugins and indentation
vim.cmd('filetype plugin indent on')

-- Set filetype for specific file extensions
vim.api.nvim_create_autocmd("BufRead", { pattern = "*.tex,*.latex", command = "set filetype=tex" })
vim.api.nvim_create_autocmd("BufRead", { pattern = "*.typ", command = "set filetype=typst" })

-- Settings for plain text editing (not code)
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.txt,*.tex,*.latex,*.md,*.typ",
  command = "set wrap linebreak nolist tw=79 wrapmargin=0 lbr fo=tro nonumber nornu"
})


local highlight_yank_group = vim.api.nvim_create_augroup('highlight_yank', {})
vim.api.nvim_create_autocmd('TextYankPost', {
  group = highlight_yank_group,
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({ timeout = 350 })
  end,
  desc = 'Highlight text on yank'
})

local no_spell_group = vim.api.nvim_create_augroup('NoSpellCheck', {})
vim.api.nvim_create_autocmd('FileType', {
  group = no_spell_group,
  pattern = { 'cs', 'rs', 'js', 'py', 'go', 'ts', 'cpp' },
  callback = function()
    vim.opt_local.spell = false
  end,
  desc = 'Disable spell check for programming languages'
})

vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function()
    if vim.fn.line("'\"") > 0 and vim.fn.line("'\"") <= vim.fn.line('$') then
      vim.cmd('normal! g`\"')
    end
  end,
  desc = 'Jump to last edit position on opening file'
})

-- Clear existing SpellBad highlight group
-- Define custom highlight for SpellBad
vim.cmd('hi SpellBad cterm=underline ctermfg=Red guifg=Red guisp=Red')

-- Define custom highlights for Telescope
vim.cmd('highlight TelescopeSelectionCaret guifg=#ff3333')
vim.cmd('highlight TelescopeSelection guifg=#D79921 gui=bold,underline')
vim.cmd('highlight TelescopePreviewLine guifg=#D79921 gui=underline')

vim.diagnostic.config {
  virtual_text = true,
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    focusable = true,
    border = "rounded",
    header = "",
    prefix = "",
  }
}
