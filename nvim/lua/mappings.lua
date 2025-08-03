vim.keymap.set('v', 'j', 'gj')
vim.keymap.set('v', 'k', 'gk')
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')

vim.keymap.set('', 'q:', ':q')
vim.keymap.set('', 'Q', '<nop>')
vim.api.nvim_create_user_command('Q', 'q', {})

vim.keymap.set('i', 'jk', '<esc>')

vim.keymap.set('i', '<C-BS>', '<C-w>', { silent = true })
vim.keymap.set('i', '<C-h>', '<C-w>', { silent = true })

vim.keymap.set('n', 'Y', 'y$', { silent = true })
vim.keymap.set('n', 'n', 'nzzzv', { silent = true })
vim.keymap.set('n', 'N', 'Nzzzv', { silent = true })

vim.keymap.set('n', '<C-j>', ':m .+1<CR>==', { silent = true })
vim.keymap.set('n', '<C-k>', ':m .-2<CR>==', { silent = true })

vim.keymap.set('i', '<C-j>', '<Esc>:m .+1<CR>==gi', { silent = true })
vim.keymap.set('i', '<C-k>', '<Esc>:m .-2<CR>==gi', { silent = true })

vim.keymap.set('v', '<C-j>', ":m '>+1<CR>gv=gv", { silent = true })
vim.keymap.set('v', '<C-k>', ":m '<-2<CR>gv=gv", { silent = true })

vim.keymap.set('', '<C-h>', '<C-w>h', { silent = true })
vim.keymap.set('', '<C-l>', '<C-w>l', { silent = true })

vim.keymap.set('i', '<C-l>', '<c-g>u<Esc>[s1z=`]a<c-g>u<Esc>ha', { noremap = true, silent = true })

-- Jump to start and end of line using home row keys
vim.keymap.set('', 'H', 'g^', { noremap = true, silent = true })
vim.keymap.set('', 'L', 'g$', { noremap = true, silent = true })

-- Mapping for repeating the last f/F motion with `;`
vim.keymap.set('n', '<Plug>NextMatch', ';', { noremap = true, silent = true })

-- Mapping for `F` that allows repeating with `.`
vim.keymap.set('n', 'F', ':<C-u>call repeat#set("\\<lt>Plug>NextMatch")<CR>F', { silent = true })

-- Mapping for `f` that allows repeating with `.`
vim.keymap.set('n', 'f', ':<C-u>call repeat#set("\\<lt>Plug>NextMatch")<CR>f', { silent = true })

-- Use <Tab> to navigate down the popup menu or insert a tab if no popup is visible
vim.keymap.set('i', '<Tab>', function()
  return vim.fn.pumvisible() == 1 and '<C-n>' or '<Tab>'
end, { expr = true, silent = true })

-- Use <S-Tab> to navigate up the popup menu or insert a Shift+Tab if no popup is visible
vim.keymap.set('i', '<S-Tab>', function()
  return vim.fn.pumvisible() == 1 and '<C-p>' or '<S-Tab>'
end, { expr = true, silent = true })


vim.keymap.set('n', 'g{', vim.diagnostic.goto_prev, { silent = true })
vim.keymap.set('n', 'g}', vim.diagnostic.goto_next, { silent = true })


-- Set the mapleader to Space
vim.g.mapleader = ' '

-- LSP
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { silent = true })
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { silent = true })
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { silent = true })
vim.keymap.set('n', '<leader>k', vim.lsp.buf.hover, { silent = true })
vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action, { silent = true })
vim.keymap.set('n', '<leader>e', function()
  vim.diagnostic.open_float(nil, { focus = false, scope = 'cursor' })
end, { silent = true })

vim.keymap.set('n', '<leader>d', '<cmd>BufferPick<CR>', { silent = true })

-- Disable arrow keys in normal mode
vim.keymap.set('n', '<right>', '<nop>', { noremap = true, silent = true })
vim.keymap.set('n', '<up>', '<nop>', { noremap = true, silent = true })
vim.keymap.set('n', '<left>', '<nop>', { noremap = true, silent = true })
vim.keymap.set('n', '<down>', '<nop>', { noremap = true, silent = true })

-- Disable arrow keys in insert mode
vim.keymap.set('i', '<up>', '<nop>', { noremap = true, silent = true })
vim.keymap.set('i', '<down>', '<nop>', { noremap = true, silent = true })
vim.keymap.set('i', '<left>', '<nop>', { noremap = true, silent = true })
vim.keymap.set('i', '<right>', '<nop>', { noremap = true, silent = true })


-- Define the CloseIfEmpty function in Lua
local function close_if_empty()
  -- Save the current buffer
  vim.cmd('write')

  -- Get the list of buffers
  local buffers = vim.api.nvim_list_bufs()

  -- Count the number of listed buffers
  local listed_buffers = 0
  for _, buf in ipairs(buffers) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_option(buf, 'buflisted') then
      listed_buffers = listed_buffers + 1
    end
  end

  -- Close the buffer or Vim based on the number of buffers
  if listed_buffers == 1 then
    vim.cmd('BufDel')
  else
    vim.cmd('BufferClose')
  end
end

vim.keymap.set('n', '<C-Space>', close_if_empty, { silent = true })
vim.keymap.set('i', '<C-Space>', function()
  vim.cmd('stopinsert')
  close_if_empty()
end, { silent = true })

-- Quick-save and exit with Ctrl-Space
vim.keymap.set('n', '<leader>w', ':w<CR>', { silent = true })

-- Navigate between buffers
vim.keymap.set('n', '<leader><Tab>', ':BufferNext<CR>', { silent = true })
vim.keymap.set('n', '<leader><S-Tab>', ':BufferPrevious<CR>', { silent = true })

-- Toggle between last two buffers
vim.keymap.set('n', '<leader><leader>', '<C-^>', { silent = true })

-- Terminal mode mappings
vim.keymap.set('t', '<leader><leader>', '<C-\\><C-n><C-^>', { silent = true })

vim.keymap.set('n', '<leader>s', function()
  require('telescope.builtin').live_grep({ layout_strategy = 'vertical' })
end, { silent = true })

vim.keymap.set('n', '<Leader>b', function()
  require('telescope.builtin').buffers(require('telescope.themes').get_dropdown({}))
end, { silent = true })

vim.keymap.set('n', '<leader>ld', '<cmd>Telescope diagnostics<CR>', { silent = true })

vim.keymap.set('n', '<Leader>r', function()
  require('telescope.builtin').lsp_references()
end, { silent = true })

vim.keymap.set('x', 'p', function()
  return 'pgv"' .. vim.v.register .. 'y'
end, { expr = true })

vim.keymap.set('n', '<C-F>', ':NvimTreeToggle<CR>', { silent = true })

vim.keymap.set('n', '<leader>m', '<cmd>HopChar1<CR>', { silent = true })

vim.api.nvim_create_augroup('HighlightTODO', {})

-- TODO
vim.api.nvim_create_autocmd({ 'WinEnter', 'VimEnter' }, {
  group = 'HighlightTODO',
  callback = function()
    vim.cmd('silent! call matchadd(\'Todo\', \'TODO\', -1)')
  end,
  desc = 'Highlight TODO comments'
})

local function search_visual_selection()
  local mode = vim.fn.visualmode()                           -- Get the visual mode ('v', 'V', or '<C-v>')
  vim.cmd('normal! ' .. mode)                                -- Re-select the visual area
  local selected_text = vim.fn.getreg('s')                   -- Store the selection in the 's' register
  vim.cmd('normal! gv"sy')                                   -- Yank the selection to the 's' register
  selected_text = vim.fn.getreg('s')                         -- Get the text from the 's' register
  selected_text = vim.fn.escape(selected_text, '\\/.*$^~[]') -- Escape special characters
  vim.fn.setreg('/', selected_text)                          -- Set the search register to the selected text
  vim.cmd('normal! /' .. selected_text .. '<CR>')            -- Perform the search
end

vim.keymap.set('x', '*', search_visual_selection, { silent = true })
