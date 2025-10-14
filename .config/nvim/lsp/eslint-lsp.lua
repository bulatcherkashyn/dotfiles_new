return {
    -- Command and arguments to start the server.
    cmd = { 'vscode-eslint-language-server', '--stdio' }, -- вместо eslint-lsp

    -- Filetypes to automatically attach to.
    filetypes = {
        'ts',
        'javascript',
        'javascriptreact',
        'javascript.jsx',
        'typescript',
        'typescriptreact',
        'typescript.tsx',
        'vue',
        'svelte',
        'astro',
    },

    -- Sets the "workspace" to the directory where any of these files is found.
    root_markers = {
        { '.eslintrc.js', '.eslintrc.cjs', '.eslintrc.yaml', '.eslintrc.yml', '.eslintrc.json', 'eslint.config.js', 'eslint.config.mjs' },
        'package.json',
        '.git',
    },

    -- Specific settings to send to the server.
    settings = {
        format = true,
        validate = 'on',
        run = 'onType',
        useESLintClass = false,
        nodePath = '',
        onIgnoredFiles = 'off',
        quiet = false,
        experimental = {
            useFlatConfig = false,
        },
        codeAction = {
            disableRuleComment = {
                enable = true,
                location = 'separateLine',
            },
            showDocumentation = {
                enable = true,
            },
        },
        workingDirectory = {
            mode = 'location',
        },
    },
}
