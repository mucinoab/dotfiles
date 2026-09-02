return {
  {
    "nvim-lua/lsp_extensions.nvim",
    ft = { "rust", "python", "javascript", "typescript", "cpp", "html", "go", "tsx", "sql", "CSS", "java", "jsx" },
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "InsertEnter",
    ft = { "rust", "python", "javascript", "typescript", "cpp", "html", "go", "tsx", "sql", "CSS", "java", "jsx" },
    opts = {
      hint_prefix = " ",
    }
  },
  -- {
  --   "j-hui/fidget.nvim",
  --   ft = { "rust", "python", "javascript", "typescript", "cpp", "html", "go", "tsx", "sql", "CSS", "java", "jsx" },
  -- },
  {
    "lukas-reineke/lsp-format.nvim",
    ft = { "rust", "python", "javascript", "typescript", "cpp", "html", "go", "tsx", "sql", "CSS", "java", "jsx" },
  },
  {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
  },
  {
    "j-hui/fidget.nvim",
    ft = { "rust", "python", "javascript", "typescript", "cpp", "html", "go", "tsx", "sql", "CSS", "java", "jsx" },
    event = "VeryLazy",
    config = function()
      require("fidget").setup {}
      require("lsp_signature").setup()
      -- require('lsp-format').setup {}

      for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
        vim.api.nvim_set_hl(0, group, {})
      end

      local capabilities = require('blink.cmp').get_lsp_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities.semanticTokensProvider = nil

      local on_attach = function(client)
        -- require("lsp-format").on_attach(client)
        -- Disable code highlight by the LSP server
        client.server_capabilities.semanticTokensProvider = nil
      end
      -- Enable diagnostics
      vim.diagnostic.config({
        virtual_text = true,
        signs = false,
        update_in_insert = false,
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          client.server_capabilities.semanticTokensProvider = nil

          if client.server_capabilities.documentHighlightProvider then
            local group = vim.api.nvim_create_augroup("lsp_document_highlight_" .. args.buf, { clear = true })
            vim.api.nvim_create_autocmd("CursorHold", {
              group = group,
              buffer = args.buf,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd("CursorMoved", {
              group = group,
              buffer = args.buf,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      });

      -- vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]] -- No auto fromat on save

      -- vim.api.nvim_create_autocmd("BufWrite", {
      --   pattern = "*.beancount",
      --   callback = function()
      --     vim.fn.system("rledger format -i " .. vim.fn.expand("%"))
      --     vim.cmd("edit!")
      --   end,
      -- })

      -- Configure LSP servers
      vim.lsp.config('ts_ls', {
        cmd = { 'typescript-language-server', '--stdio' },
        filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx' },
        root_markers = { 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' },
        capabilities = capabilities,
        on_attach = on_attach,
      })

      vim.lsp.config('clangd', {
        cmd = { 'clangd' },
        filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
        root_markers = { '.clangd', '.clang-tidy', '.clang-format', 'compile_commands.json', 'compile_flags.txt', '.git' },
        capabilities = capabilities,
        on_attach = on_attach,
      })

      vim.lsp.config('html', {
        cmd = { 'vscode-html-language-server', '--stdio' },
        filetypes = { 'html' },
        root_markers = { 'package.json', '.git' },
        capabilities = capabilities,
      })

      vim.lsp.config('ty', {
        cmd = { 'ty', 'server' },
        filetypes = { 'python', 'py' },
        capabilities = capabilities,
        on_attach = on_attach,
      })

      vim.lsp.config('cssls', {
        cmd = { 'vscode-css-language-server', '--stdio' },
        filetypes = { 'css', 'scss', 'less' },
        root_markers = { 'package.json', '.git' },
        capabilities = capabilities,
        on_attach = on_attach,
      })

      vim.lsp.config('gopls', {
        cmd = { "gopls", "serve" },
        filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
        root_markers = { 'go.work', 'go.mod', '.git' },
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
              nilness = true,
              simplifyrange = true,
              unusedwrite = true,
            },
            staticcheck = true,
          },
        },
        capabilities = capabilities,
        on_attach = on_attach,
      })

      vim.lsp.config('rust_analyzer', {
        cmd = { 'rust-analyzer' },
        filetypes = { 'rust' },
        root_markers = { 'Cargo.toml', 'rust-project.json', '.git' },
        settings = {
          ["rust-analyzer"] = {
            -- checkOnSave = {
            --   extraArgs = { "--target-dir", "/tmp/rust-analyzer-check" }
            -- },
            cargo = { loadOutDirsFromCheck = true, allFeatures = true },
            procMacro = { enable = true },
            diagnostics = {
              enable = true,
              disabled = { "unresolved-proc-macro" },
              enableExperimental = true,
            },
          }
        },
        capabilities = capabilities,
        on_attach = on_attach,
      })

      vim.lsp.config('rledger', {
        cmd = { 'rledger-lsp' },
        filetypes = { 'beancount' },
        root_markers = { '.git'},
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- Enable all configured LSP servers
      vim.lsp.enable({ 'ts_ls', 'clangd', 'html', 'ty', 'cssls', 'gopls', 'rledger', 'rust_analyzer' })

      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.rs",
        callback = function()
          vim.lsp.buf.format()
        end,
      })
    end
  },
}
