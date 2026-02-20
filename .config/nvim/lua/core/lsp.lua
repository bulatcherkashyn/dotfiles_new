vim.lsp.enable({
    "gopls",
    "lua_ls",
    "vtsls",
    "dockerls",
    "jsonls",
    "prismals",
    "sqlls",
    --"biome",
    "rust-analyzer",
    "yamlls",
})

vim.diagnostic.config({
    virtual_lines = true,
    --virtual_text = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        border = "rounded",
        source = true,
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.INFO] = "󰋽 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
        },
        numhl = {
            [vim.diagnostic.severity.ERROR] = "ErrorMsg",
            [vim.diagnostic.severity.WARN] = "WarningMsg",
        },
    },
})


vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        if client.name == 'vtsls' then
            local opts = { buffer = args.buf }

            -- Code actions (добавить импорт)
            vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)

            vim.keymap.set('n', '<leader>oi', function()
                vim.lsp.buf.code_action({
                    context = {
                        only = { 'source.organizeImports' },
                        diagnostics = {},
                    },
                    apply = true,
                })
            end, opts)

            -- Add missing imports
            vim.keymap.set('n', '<leader>ai', function()
                vim.lsp.buf.code_action({
                    context = { only = { 'source.addMissingImports.ts' } },
                    apply = true,
                })
            end, opts)
        end
    end,
})
