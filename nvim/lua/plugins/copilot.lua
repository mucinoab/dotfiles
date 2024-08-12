return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    ft = {"rust", "python", "javascript", "typescript", "cpp", "html", "go", "markdown", "json", "java", "c", "typst", "kdl", "tsx", "lua", "sql" },
    config = function()
      require("copilot").setup({
        panel = { enabled = false },
        suggestion = { enabled = false },
        filetypes = { help = false, gitcommit = false, gitrebase = false }
      })
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    ft = {"rust", "python", "javascript", "typescript", "cpp", "html", "go", "markdown", "json", "java", "c", "typst", "kdl", "tsx", "lua", "sql" },
    dependencies = { 
      "zbirenbaum/copilot.lua"
    },
    config = function ()
      require("copilot_cmp").setup()
    end
  },
}
