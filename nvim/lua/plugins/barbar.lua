return {
  {
    'romgrk/barbar.nvim',
    init = function() vim.g.barbar_auto_setup = false end,
    opts = {
      icons = { filetype = { enabled = false } },
      insert_at_end = true,
      clickable = true,
      semantic_letters = false,
      tabpages = false,
      auto_hide = true,
      animation = false,
    }
  }
}
