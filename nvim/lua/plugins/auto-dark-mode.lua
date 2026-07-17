return {
  'f-person/auto-dark-mode.nvim',
  opts = {
    set_dark_mode = function()
      vim.cmd('colorscheme github_dark_default')
    end,
    set_light_mode = function()
      vim.cmd('colorscheme github_light')
    end,
  },
}
