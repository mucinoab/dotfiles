return {
  'projekt0n/github-nvim-theme',
  lazy = false,
  priority = 1000,
  config = function()
    require('github-theme').setup({
      groups = {
        -- The stock dark selection (#17335a) sits at ~1.5:1 against the
        -- editor background, which is nearly invisible. Brighten the bg and
        -- force the selected text white so it reads at any syntax color.
        github_dark_default = {
          Visual = { bg = '#3d76b8', fg = '#ffffff' },
          VisualNOS = { bg = '#3d76b8', fg = '#ffffff' },
        },
      },
    })
    vim.api.nvim_create_autocmd('ColorScheme', {
      callback = function()
        vim.cmd('highlight Whitespace guifg=#e0a0a0')
        -- modes.nvim swaps Visual for these while selecting. It defines them
        -- with `hi default`, so an explicit `hi` here wins and keeps the
        -- selected text white regardless of syntax color.
        vim.cmd('highlight ModesVisualVisual guibg=#3d76b8 guifg=#ffffff')
        vim.cmd('highlight ModesSelectVisual guibg=#3d76b8 guifg=#ffffff')
      end,
    })
    vim.cmd('colorscheme github_light')
  end
}
