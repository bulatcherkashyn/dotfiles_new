local map = vim.keymap.set
return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    local on_attach = function(client, bufnr)
      local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

      local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

      buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
      local opts = { noremap = true, silent = true }

      buf_set_keymap('n', 'gD', '<cmd>Telescope lsp_type_definitions<CR>', opts)
      buf_set_keymap('n', 'gd', '<cmd>Telescope lsp_definitions<CR>', opts)
      buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
      buf_set_keymap('n', 'gh', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
      buf_set_keymap('n', 'gi', '<cmd>Telescope lsp_implementations<CR>', opts)
      buf_set_keymap('n', 'gr', '<cmd>Telescope lsp_references<CR>', opts)
      buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
      buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
      buf_set_keymap('n', '<leader>ll', '<cmd>lua vim.lsp.codelens.run()<cr>', opts)
      client.server_capabilities.document_formatting = true
    end

    -- local on_attach = function(_, bufnr)
    -- local function opts(desc)
    -- return { buffer = bufnr, desc = "LSP " .. desc }
    -- end
    --
    -- map("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
    -- map("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
    -- map("n", "gi", vim.lsp.buf.implementation, opts "Go to implementation")
    -- map("n", "<leader>sh", vim.lsp.buf.signature_help, opts "Show signature help")
    -- map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts "Add workspace folder")
    -- map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts "Remove workspace folder")
    --
    -- map("n", "<leader>wl", function()
    -- print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    -- end, opts "List workspace folders")
    --
    -- map("n", "<leader>D", vim.lsp.buf.type_definition, opts "Go to type definition")
    --
    -- map("n", "<leader>ra", function()
    -- require "nvchad.lsp.renamer" ()
    -- end, opts "NvRenamer")
    --
    -- map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts "Code action")
    -- map("n", "gr", vim.lsp.buf.references, opts "Show references")
    -- end

    require("neodev").setup({
      library = { plugins = { "nvim-dap-ui" }, types = true },
    })
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    --
    --local capabilities = cmp_nvim_lsp.default_capabilities()

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    local lsp_flags = {
      allow_incremental_sync = true,
      debounce_text_changes = 150,
    }

    local lspui = require("lspconfig.ui.windows")
    vim.cmd([[autocmd BufWritePre * lua vim.lsp.buf.format()]])

    lspui.default_options.border = "double"


    require('lspconfig').emmet_ls.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      flags = lsp_flags
    }

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
