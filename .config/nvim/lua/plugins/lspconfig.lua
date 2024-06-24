return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
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
      settings = {
        Lua = {
          diagnostics = {
            globals = { 'vim' }
          }
        }
      }
    })

    require('lspconfig').tsserver.setup({
      capabilities = capabilities,
    })
    require('lspconfig').eslint.setup({
      capabilities = capabilities,
    })
    require('lspconfig').html.setup({
      capabilities = capabilities,
    })
    require('lspconfig').rust_analyzer.setup({
      capabilities = capabilities,
      -- Server-specific settings. See `:help lspconfig-setup`
      settings = {
        ["rust-analyzer"] = {},
      },
    })
  end
}
