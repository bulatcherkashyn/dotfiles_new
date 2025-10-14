return {
    cmd = { 'yaml-language-server', '--stdio' },

    filetypes = { 'yaml', 'yaml.docker-compose', 'yaml.gitlab' },

    root_markers = { '.git' },

    single_file_support = true,

    settings = {
        yaml = {
            schemaStore = {
                enable = false,
                url = '',
            },

            schemas = require('schemastore').yaml.schemas(),

            validate = true,

            format = {
                enable = true,
            },

            hover = true,

            completion = true,
        },
    },
}
