return {
    {
        "williamboman/mason.nvim",
        config = function()
            require('mason').setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗"
                    }
                }
            })
        end
    },
    {
        'mason-org/mason-lspconfig.nvim',
        dependencies = { 'mason-org/mason.nvim' },
        opts = {
            ensure_installed = {
                'dockerls', -- docker-langserver
                'gopls', -- gopls
                'jsonls', -- vscode-json-language-server
                'lua_ls', -- lua-language-server
                'prismals', -- prisma-language-server
                'rust_analyzer', -- rust-analyzer
                'sqlls', -- sql-language-server
                'vtsls', -- vtsls
                'yamlls', -- yaml-language-server
            },
            -- автоматически делает vim.lsp.enable() для установленных серверов
            automatic_enable = true,
        },
    },
}
