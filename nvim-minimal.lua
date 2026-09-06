-- ssh <host> 'mkdir -p ~/.config/nvim' && scp ~/Dotfiles/nvim-minimal.lua <host>:.config/nvim/init.lua

vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'
vim.g.loaded_spellfile_plugin = 1

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable',
    'https://github.com/folke/lazy.nvim.git', lazypath })
end

if (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.opt.rtp:prepend(lazypath)
  require('lazy').setup({
    spec = {
      { 'lambdalisue/vim-suda' },
      {
        'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        keys = {
          { '<leader>f',  function() require('telescope.builtin').find_files() end },
          { '<leader>s',  function() require('telescope.builtin').live_grep({ layout_strategy = 'vertical' }) end },
          { '<leader>b',  function() require('telescope.builtin').buffers(require('telescope.themes').get_dropdown({})) end },
          { '<leader>r',  function() require('telescope.builtin').lsp_references() end },
          { '<leader>ld', '<cmd>Telescope diagnostics<cr>' },
        },
        opts = function()
          return {
            defaults = {
              layout_config = { vertical = { width = 0.99 } },
              vimgrep_arguments = { 'rg', '--color=never', '--no-heading',
                '--with-filename', '--line-number', '--column', '--smart-case' },
              winblend = 15,
              mappings = { i = { ['<esc>'] = require('telescope.actions').close } },
              set_env = { COLORTERM = 'truecolor' },
            },
          }
        end,
      },
    },
    checker = { enabled = false },
    change_detection = { notify = false },
    performance = { rtp = { reset = false } },
  })
end

local o = vim.o

o.shiftwidth, o.tabstop = 2, 2
o.expandtab, o.smartindent, o.smarttab, o.shiftround = true, true, true, true
o.hlsearch = false
o.ignorecase, o.smartcase, o.gdefault = true, true, true
o.number, o.cursorline, o.title = true, true, true
o.scrolloff = 1000
o.undofile = true
o.clipboard = 'unnamedplus'
o.list, o.listchars = true, 'trail:•'
o.updatetime, o.synmaxcol = 100, 800
o.formatoptions = 'tcrqnb'
o.spell, o.spelllang = true, 'es,en'
o.showmode = false
o.laststatus = 3
o.showtabline = 2
o.wildmode = 'longest,full'
o.wildoptions = 'pum'
o.completeopt = 'menuone,noselect,fuzzy'
o.winborder = 'rounded'
vim.opt.shortmess:append('c')

vim.g.netrw_liststyle = 3
vim.g.netrw_banner = 0
vim.g.netrw_winsize = -40

vim.diagnostic.config({
  virtual_text = true,
  underline = true,
  severity_sort = true,
  update_in_insert = false,
  signs = false,
})

vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    vim.api.nvim_set_hl(0, 'SpellBad', { underline = true, fg = 'Red', sp = 'Red' })
    vim.api.nvim_set_hl(0, 'Whitespace', { fg = '#e0a0a0' })
    vim.api.nvim_set_hl(0, 'TelescopeSelectionCaret', { fg = '#ff3333' })
    vim.api.nvim_set_hl(0, 'TelescopeSelection', { fg = '#d79921', bold = true, underline = true })
    vim.api.nvim_set_hl(0, 'TelescopePreviewLine', { fg = '#d79921', underline = true })
  end,
})

o.background = vim.env.NVIM_BACKGROUND or 'light'
vim.cmd.colorscheme('default')

local mode_names = {
  n = 'NORMAL', i = 'INSERT', v = 'VISUAL', V = 'V-LINE', ['\22'] = 'V-BLOCK',
  s = 'SELECT', R = 'REPLACE', c = 'COMMAND', t = 'TERMINAL',
}

function _G.Statusline()
  local mode = mode_names[vim.fn.mode()] or vim.fn.mode()
  return ' ' .. mode .. ' %#StatusLineNC# %t%m%r%h%w'
      .. '%=%{&filetype} %{&fileencoding} %l:%c %P '
end

function _G.Tabline()
  local out, cur = {}, vim.api.nvim_get_current_buf()
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[b].buflisted then
      local name = vim.api.nvim_buf_get_name(b)
      name = name == '' and '[No Name]' or vim.fn.fnamemodify(name, ':t')
      out[#out + 1] = (b == cur and '%#TabLineSel#' or '%#TabLine#')
          .. ' ' .. name .. (vim.bo[b].modified and ' +' or '') .. ' '
    end
  end
  return table.concat(out) .. '%#TabLineFill#'
end

o.statusline = '%!v:lua.Statusline()'
o.tabline = '%!v:lua.Tabline()'

local map = vim.keymap.set
local sil = { silent = true }

map({ 'n', 'v' }, 'j', 'gj')
map({ 'n', 'v' }, 'k', 'gk')

map('n', 'q', '<Nop>')
map('n', 'Q', 'q')
map({ 'x', 'o' }, 'Q', '<Nop>')
map('', 'q:', ':q')
vim.api.nvim_create_user_command('Q', 'q', {})

map('i', 'jk', '<Esc>')
map('i', '<C-BS>', '<C-w>', sil)
map('i', '<C-h>', '<C-w>', sil)
map('i', '<C-l>', '<c-g>u<Esc>[s1z=`]a<c-g>u<Esc>ha', sil)

map('n', 'n', 'nzzzv', sil)
map('n', 'N', 'Nzzzv', sil)

map('', 'H', 'g^', sil)
map('', 'L', 'g$', sil)

map('n', '<C-j>', ':m .+1<CR>==', sil)
map('n', '<C-k>', ':m .-2<CR>==', sil)
map('i', '<C-j>', '<Esc>:m .+1<CR>==gi', sil)
map('i', '<C-k>', '<Esc>:m .-2<CR>==gi', sil)
map('v', '<C-j>', ":m '>+1<CR>gv=gv", sil)
map('v', '<C-k>', ":m '<-2<CR>gv=gv", sil)

map('', '<C-h>', '<C-w>h', sil)
map('', '<C-l>', '<C-w>l', sil)

map('n', '<right>', '<Nop>')
map('n', '<up>', '<Nop>')
map('n', '<left>', '<Nop>')
map('n', '<down>', '<Nop>')
map('i', '<right>', '<Nop>')
map('i', '<up>', '<Nop>')
map('i', '<left>', '<Nop>')
map('i', '<down>', '<Nop>')

map('x', 'p', function() return 'pgv"' .. vim.v.register .. 'y' end, { expr = true })

map('x', '*', function()
  local lines = vim.fn.getregion(vim.fn.getpos('v'), vim.fn.getpos('.'), { type = vim.fn.mode() })
  local pat = '\\V' .. vim.fn.escape(table.concat(lines, '\n'), '\\/')
  vim.cmd.normal({ vim.keycode('<Esc>'), bang = true })
  vim.fn.setreg('/', pat)
  vim.fn.histadd('/', pat)
  vim.cmd.normal({ 'n', bang = true })
end, sil)

map('n', 'g{', function() vim.diagnostic.jump({ count = -1, float = true }) end, sil)
map('n', 'g}', function() vim.diagnostic.jump({ count = 1, float = true }) end, sil)
map('n', '<leader>e', function() vim.diagnostic.open_float(nil, { focus = false, scope = 'cursor' }) end, sil)
map('n', 'gd', vim.lsp.buf.definition, sil)
map('n', 'gD', vim.lsp.buf.declaration, sil)
map('n', 'gi', vim.lsp.buf.implementation, sil)
map('n', '<leader>k', vim.lsp.buf.hover, sil)
map('n', '<leader>a', vim.lsp.buf.code_action, sil)

map('n', '<leader>t', function()
  o.background = o.background == 'dark' and 'light' or 'dark'
end, sil)

map('n', '<leader>w', '<cmd>write<CR>', sil)
map('n', '<leader><Tab>', '<cmd>bnext<CR>', sil)
map('n', '<leader><S-Tab>', '<cmd>bprevious<CR>', sil)
map('n', '<leader><leader>', '<C-^>', sil)
map('t', '<leader><leader>', [[<C-\><C-n><C-^>]], sil)
map('n', '<C-F>', '<cmd>Lexplore!<CR>', sil)

local function close_buffer()
  local buf = vim.api.nvim_get_current_buf()
  if vim.api.nvim_buf_get_name(buf) ~= '' and vim.bo[buf].modified then
    vim.cmd.write()
  end
  local listed = 0
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[b].buflisted then listed = listed + 1 end
  end
  vim.cmd(listed <= 1 and 'quit' or 'bdelete')
end

map('n', '<C-Space>', close_buffer, sil)
map('i', '<C-Space>', function()
  vim.cmd.stopinsert()
  close_buffer()
end, sil)

local aug = vim.api.nvim_create_augroup('minimal', { clear = true })
local au = function(event, opts)
  vim.api.nvim_create_autocmd(event, vim.tbl_extend('force', { group = aug }, opts))
end

au('TextYankPost', {
  callback = function() vim.hl.on_yank({ timeout = 350 }) end,
})

au({ 'WinEnter', 'VimEnter' }, {
  callback = function()
    if not vim.w.todo_match then
      vim.w.todo_match = vim.fn.matchadd('Todo', 'TODO', -1)
    end
  end,
})

au('BufReadPost', {
  callback = function()
    local mark = vim.fn.line([['"]])
    if mark > 0 and mark <= vim.fn.line('$') then vim.cmd('normal! g`"') end
  end,
})

au('BufRead', {
  pattern = { '*.orig', '*.pacnew' },
  callback = function() vim.bo.readonly = true end,
})

au({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.typ',
  callback = function() vim.bo.filetype = 'typst' end,
})

au('FileType', {
  pattern = { 'text', 'tex', 'plaintex', 'markdown', 'typst' },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.textwidth = 79
    vim.opt_local.formatoptions = 'tro'
  end,
})

au('FileType', {
  pattern = { 'c', 'cpp', 'cs', 'go', 'java', 'javascript', 'lua', 'python', 'rust', 'typescript' },
  callback = function() vim.opt_local.spell = false end,
})
