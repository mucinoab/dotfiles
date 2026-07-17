return {
  'projekt0n/github-nvim-theme',
  lazy = false,
  priority = 1000,
  config = function()
    require('github-theme').setup()
    vim.api.nvim_create_autocmd('ColorScheme', {
      callback = function()
        vim.cmd('highlight Whitespace guifg=#e0a0a0')
      end,
    })
    vim.cmd('colorscheme github_light')
  end
}
