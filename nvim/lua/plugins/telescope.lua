return {
  'nvim-telescope/telescope.nvim',
  lazy = false,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-fzy-native.nvim',
  },
  config = function()
    local actions = require('telescope.actions')
    require('telescope').setup({
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
        mappings = { i = { ["<esc>"] = actions.close } },
        set_env = { ['COLORTERM'] = 'truecolor' },
      },
    })
    require('telescope').load_extension('fzy_native')
  end,
}
