return {
    cmd = { 'biome', 'lsp-proxy' },

    filetypes = {
        'javascript',
        'javascriptreact',
        'typescript',
        'typescriptreact',
        'json',
        'jsonc',
    },

    -- root_dir определится автоматически (ищет biome.json)
    single_file_support = false,

    on_attach = function(client, bufnr)
        -- Включить форматирование
        client.server_capabilities.documentFormattingProvider = true

        -- Keybindings
        local opts = { buffer = bufnr, noremap = true, silent = true }
        vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, opts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)

        -- Format on save
        vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format({ async = false })
            end,
        })
    end,
}
