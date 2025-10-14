return {
    cmd = { '/home/busyok/.nvm/versions/node/v22.20.0/bin/biome', 'lsp-proxy' },
    filetypes = {
        'javascript',
        'javascriptreact',
        'javascript.jsx',
        'typescript',
        'typescriptreact',
        'typescript.tsx',
        'json',
        'jsonc',
    },

    root_markers = { 'biome.json', 'biome.jsonc', '.git' },

    single_file_support = false,
}
