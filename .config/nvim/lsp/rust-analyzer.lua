return {
    cmd = { 'rust-analyzer' },

    filetypes = { 'rust' },

    root_markers = { 'Cargo.toml', 'rust-project.json' },

    single_file_support = true,

    settings = {
        ['rust-analyzer'] = {
            -- Cargo
            cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                buildScripts = {
                    enable = true,
                },
            },

            -- Процедурные макросы
            procMacro = {
                enable = true,
            },

            -- Проверка кода
            checkOnSave = true,

            -- Диагностика
            diagnostics = {
                enable = true,
                experimental = {
                    enable = true,
                },
            },
        },
    },
}
