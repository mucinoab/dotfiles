return {
  'nvim-telescope/telescope.nvim',
  lazy = false,
  dependencies = { 
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-fzy-native.nvim',
  },
  opts = {
    defaults = {
      layout_config = {
        vertical = { width = 0.99 }
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
      winblend = 15,
      mappings = { i = { ["<esc>"] = require('telescope.actions').close } },
      set_env = { ['COLORTERM'] = 'truecolor' },
    },
  },
  init = function()
	require('telescope').load_extension('fzy_native')
  end,
}
