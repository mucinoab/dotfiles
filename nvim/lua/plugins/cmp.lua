return {
  {
    "saghen/blink.cmp",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    version = "*",
    event = "InsertEnter",
    opts = {
      keymap = {
        preset = 'none',
        ['<Tab>'] = {
          function(cmp)
            if cmp.snippet_active() then
              return cmp.snippet_forward()
            elseif cmp.is_visible() then
              local list = require('blink.cmp.completion.list')
              if #list.items == 1 then
                return cmp.accept()
              else
                return cmp.select_next()
              end
            end
          end,
          'fallback'
        },
        ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
        ['<Down>'] = { 'select_next', 'fallback' },
        ['<Up>'] = { 'select_prev', 'fallback' },
        ['<CR>'] = { 'accept', 'fallback' },
      },
      sources = {
        default = function(ctx)
          local success, node = pcall(vim.treesitter.get_node)

          if success and node and vim.tbl_contains({ 'comment', 'line_comment', 'block_comment' }, node:type()) then
            return { 'buffer' }
          else
            return { 'lsp', 'path', 'snippets', 'buffer' }
          end
        end
      },
      completion = {
        list = {
          selection = {
            preselect = true,
            auto_insert = true,
          }
        },
      },
      signature = { enabled = false },
    },
    config = function(_, opts)
      require('blink.cmp').setup(opts)
    end,
  }
}
