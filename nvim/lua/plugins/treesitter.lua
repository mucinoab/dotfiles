return {
  {
    priority = 500,
    "nvim-treesitter/nvim-treeSitter",
    build = ":TSUpdate",
    dependencies = { "nvim-treesitter/nvim-treesitter-refactor" },
    ft = {"rust", "python", "javascript", "typescript", "cpp", "html", "go", "markdown", "json", "java", "c", "typst", "kdl", "tsx", "lua", "sql"},
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = {"rust", "python", "javascript", "typescript", "cpp", "html", "go", "markdown", "json", "java", "c", "typst", "kdl", "tsx", "lua", "sql"},
        highlight = { enable = true, additional_vim_regex_highlighting = false, disable = { "c_sharp" } },
        indent = { enable = true },
        refactor = {
          highlight_definitions = { enable = true },
          smart_rename = {
            enable = true,
            keymaps = {
              smart_rename = "grr",
            },
          },
        },
      }
    end
  }
}
