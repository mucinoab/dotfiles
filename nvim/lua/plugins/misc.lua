return {
  {
    "ojroques/nvim-bufdel",
    event = "VeryLazy",
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
    },
    event = "VeryLazy",
  }, 
  {
    "lukas-reineke/lsp-format.nvim",
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    ft = { 'cpp', 'python', 'rust', 'go', 'javascript', 'typescript', 'cs', 'c', 'java', 'js' },
    main = "ibl",
    opts = { enabled = true }
  },
  {
    "chaoren/vim-wordmotion",
    event = "VeryLazy",
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
    "tpope/vim-repeat",
    event = "VeryLazy",
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
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = { icons_enabled = false, theme = 'wombat', },
      sections = {
        lualine_b = {'filename'},
        lualine_x = {'encoding', 'filetype'},
      },
    }
  },
  {
    "rmagatti/auto-session",
    opts = {
      log_level = 'error',
      auto_session_enable_last_session = false,
      auto_session_root_dir = vim.fn.stdpath('data').."/sessions/",
      auto_session_enabled = true,
      auto_save_enabled = false,
      auto_restore_enabled = false,
      auto_session_suppress_dirs = nil
    },
    event = "VeryLazy",
  },
  {
    "smoka7/hop.nvim",
    opts = {
        keys = 'etovxqpdygfblzhckisuran'
    },
    event = "VeryLazy",
  },
  {
    "mvllow/modes.nvim",
    opts = {
      line_opacity = 0.1,
      set_cursor = true,
      focus_only = false
    },
  },
  {
    "karb94/neoscroll.nvim",
    config = function ()
      require('neoscroll').setup({})
    end
  }
}
