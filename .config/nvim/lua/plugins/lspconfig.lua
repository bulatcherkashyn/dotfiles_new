local map = vim.keymap.set
return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    local on_attach = function(_, bufnr)
      local function opts(desc)
        return { buffer = bufnr, desc = "LSP " .. desc }
      end

      map("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
      map("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
      map("n", "gi", vim.lsp.buf.implementation, opts "Go to implementation")
      map("n", "<leader>sh", vim.lsp.buf.signature_help, opts "Show signature help")
      map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts "Add workspace folder")
      map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts "Remove workspace folder")

      map("n", "<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, opts "List workspace folders")

      map("n", "<leader>D", vim.lsp.buf.type_definition, opts "Go to type definition")

      map("n", "<leader>ra", function()
        require "nvchad.lsp.renamer" ()
      end, opts "NvRenamer")

      map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts "Code action")
      map("n", "gr", vim.lsp.buf.references, opts "Show references")
    end

    require("neodev").setup({
      library = { plugins = { "nvim-dap-ui" }, types = true },
    })
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local capabilities = cmp_nvim_lsp.default_capabilities()
    local lspui = require("lspconfig.ui.windows")
    vim.cmd([[autocmd BufWritePre * lua vim.lsp.buf.format()]])

    lspui.default_options.border = "double"

    require('lspconfig').lua_ls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        Lua = {
          diagnostics = {
            globals = { 'vim' }
          }
        }
      }
    })

    require('lspconfig').rust_analyzer.setup({
      capabilities = capabilities,
      -- Server-specific settings. See `:help lspconfig-setup`
      settings = {
        ["rust-analyzer"] = {},
      },
    })

    local servers = { "tsserver", "eslint", "tailwindcss", "html" };
    for _, lsp in ipairs(servers) do
      require('lspconfig')[lsp].setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })
    end
  end
}
