return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = { 
      "l3mon4d3/luasnip",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "lukas-reineke/cmp-under-comparator",
      "saadparwaiz1/cmp_luasnip",
    },
    event = "InsertEnter",
    opts =  function(_, opts)
      --- completion stuff
      -- https://github.com/hrsh7th/nvim-cmp/issues/156#issuecomment-916338617
      -- Custom comparators based on a given priority
      local lspkind_comparator = function(conf)
        local lsp_types = require('cmp.types').lsp
        return function(entry1, entry2)
          if entry1.source.name ~= 'nvim_lsp' then
            if entry2.source.name == 'nvim_lsp' then
              return false
            else
              return nil
            end
          end
          local kind1 = lsp_types.CompletionItemKind[entry1:get_kind()]
          local kind2 = lsp_types.CompletionItemKind[entry2:get_kind()]

          local priority1 = conf.kind_priority[kind1] or 0
          local priority2 = conf.kind_priority[kind2] or 0
          if priority1 == priority2 then
            return nil
          end
          return priority2 < priority1
        end
      end

      -- Lexicographical order (?)
      local label_comparator = function(entry1, entry2)
        return entry1.completion_item.label < entry2.completion_item.label
      end

      local kind_icons = {
        Text = "", Method = "", Function = "", Constructor = "",
        Field = "", Variable = "", Class = "ﴯ", Interface = "",
        Module = "", Property = "ﰠ", Unit = "", Value = "",
        Enum = "", Keyword = "", Snippet = "", Color = "",
        File = "", Reference = "", Folder = "", EnumMember = "",
        Constant = "", Struct = "", Event = "", Operator = "",
        TypeParameter = "", Copilot = ""
      }

      -- Configs
      local cmp = require("cmp")

      opts.mapping = cmp.mapping.preset.insert({
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        ['<CR>'] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = false,
        })
      })

      opts.snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end
      }
      opts.sources = {
        { name = 'nvim_lsp' },
        { name = 'copilot' },
        { name = 'luasnip' },
        { name = 'buffer', options = { keyword_pattern = [[\k\+]] } },
        { name = 'path' },
        { name = 'treesitter' },
      }
      opts.sorting = {
        priority_weight = 2,
        comparators = {
          require("cmp-under-comparator").under,
          -- require("copilot_cmp.comparators").prioritize,
          lspkind_comparator({
            kind_priority = {
              Field = 11, Property = 11, Method = 11,
              Constant = 10, Enum = 10, EnumMember = 10,
              Event = 10, Function = 10, Operator = 10,
              Reference = 10, Struct = 10, Variable = 12,
              File = 8, Folder = 8, Class = 5,
              Color = 5, Module = 5, Keyword = 2,
              Constructor = 1, Interface = 1, Text = 1,
              TypeParameter = 1, Unit = 1, Value = 1,
              Snippet = -1,
            },
          }),
          label_comparator,
        },
      }
      opts.formatting = {
        format = function(_, vim_item)
          vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
          return vim_item
        end
      }

      cmp.setup.filetype({ "sql" }, {
        sources = {
          { name = 'vim-dadbod-completion' },
          { name = 'buffer' },
        }
      })

    end
  }
}
