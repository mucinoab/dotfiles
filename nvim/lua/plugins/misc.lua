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
      signcolumn      = false,
      numhl           = true,
      watch_gitdir    = { interval = 15000, follow_files = true },
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
        lualine_b = { 'filename' },
        lualine_x = { 'encoding', 'filetype' },
      },
    }
  },
  {
    "rmagatti/auto-session",
    opts = {
      log_level = 'error',
      auto_session_enable_last_session = false,
      auto_session_root_dir = vim.fn.stdpath('data') .. "/sessions/",
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
      -- While in visual mode modes.nvim remaps Visual -> ModesVisualVisual via
      -- winhighlight, so THIS is what a selection renders as, not the
      -- colorscheme's Visual. Its default is #9745be blended at line_opacity
      -- against the bg, which at 0.1 came out a near-invisible dark purple.
      colors = { visual = '#3d76b8' },
      line_opacity = {
        copy = 0.1,
        delete = 0.1,
        change = 0.1,
        format = 0.1,
        insert = 0.1,
        replace = 0.1,
        -- For visual/select the cursorline tint is hardcoded to 'none', so this
        -- opacity only affects the selection: 1 = use the color as-is.
        select = 1,
        visual = 1,
      },
      set_cursor = true,
      focus_only = false
    },
  },
  {
    "lambdalisue/vim-suda"
  },
  {
    "obsidian-nvim/obsidian.nvim",
    init = function()
      vim.opt.conceallevel = 2
    end,
    event = {
      "BufReadPre /home/bmucino/Documents/second-brain/*.md",
      "BufNewFile /home/bmucino/Documents/second-braint/*.md",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      legacy_commands = false,
      ui = {
        bullets = {},
      },
      workspaces = {
        {
          name = "personal",
          path = "~/Documents/second-brain/",
        },
      },
      completion = {
        nvim_cmp = false,
        min_chars = 2,
      },
      templates = {
        folder = "templates",
      },
      note_id_func = function(title)
        local suffix = ""
        if title ~= nil then
          -- If title is given, transform it into valid file name.
          suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          -- If title is nil, just add 4 random uppercase letters to the suffix.
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return suffix .. "-" .. tostring(os.date("%d-%m-%y"))
      end,
    },
  },
  {
    "dmtrKovalenko/fff.nvim",
    build = function()
      -- downloads a prebuilt binary or falls back to cargo build
      require("fff.download").download_or_build_binary()
    end,
    opts = {
      prompt = '> ',
      max_results = 32,
      max_threads = 4,
      -- keymaps = {
      --   move_up = { '<Up>', '<C-p>', 'j' },
      --   move_down = { '<Down>', '<C-n>', 'k'},
      -- },
    },
    keys = {
      {
        "<leader>f",
        function()
          require("fff").find_files()
        end,
        desc = "Open file picker",
      },
    },
  },
}
