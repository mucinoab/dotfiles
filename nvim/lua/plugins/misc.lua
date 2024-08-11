return {
  {
    "ojroques/nvim-bufdel",
    lazy = false
  },
  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      view = {
        width = 40,
        side = "right",
        debounce_delay = 150,
      },
      filters = { dotfiles = true }
    }
  }, 
  {
    "lukas-reineke/lsp-format.nvim",
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
  },
  {
    "chaoren/vim-wordmotion",
    lazy = false
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signcolumn = false,
      numhl      = true,
      watch_gitdir = { interval = 15000, follow_files = true },
      update_debounce = 100,
      max_file_length = 4000,
    }
  },
  {
    "tpope/vim-repeat"
  },
  {
    "petertriho/nvim-scrollbar",
    opts = {
      show = true,
      handle = {
        text = " ",
        color = "gray",
        hide_if_all_visible = true,
      },
      marks = {
        Search = { text = { "--", "==" }, priority = 0, color = "orange" },
        Error = { text = { "--", "==" }, priority = 1, color = "red" },
        Warn = { text = { "--", "==" }, priority = 2, color = "yellow" },
        Info = { text = { "--", "==" }, priority = 3, color = "blue" },
        Hint = { text = { "--", "==" }, priority = 4, color = "green" },
        Misc = { text = { "--", "==" }, priority = 5, color = "purple" },
      },
      excluded_filetypes = {
        "",
        "prompt",
        "TelescopePrompt",
      },
      autocmd = {
        render = {
          "BufWinEnter",
          "TabEnter",
          "TermEnter",
          "WinEnter",
          "CmdwinLeave",
          "TextChanged",
          "VimResized",
          "WinScrolled",
        },
      },
      handlers = {
        diagnostic = true,
        search = false,
      },
    }
  },{
    "nvim-lualine/lualine.nvim",
    opts = {
      options = { icons_enabled = false, theme = 'wombat', },
      sections = {
        lualine_b = {'filename'},
        lualine_x = {'encoding', 'filetype'},
      },
    }
  }
}
