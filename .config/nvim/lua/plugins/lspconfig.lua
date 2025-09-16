local map = vim.keymap.set

return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "saghen/blink.cmp",
        "williamboman/mason-lspconfig.nvim",
        "williamboman/mason.nvim",
        "yioneko/nvim-vtsls"
    },
    opts = {},
    config = function(_, opts)
        local function organize_imports()
            local params = {
                command = "_typescript.organizeImports",
                arguments = { vim.api.nvim_buf_get_name(0) },
                title = "",
            }
            vim.lsp.buf.execute_command(params)
        end
        require("mason").setup()

        require("mason-lspconfig").setup({
            ensure_installed = { "lua_ls", "ts_ls", "eslint", "jsonls", "vtsls", "rescriptls", "biome" },
        })

        local blink = require("blink.cmp")
        local lspconfig = require("lspconfig")

        -- В вашей on_attach функции для LSP
        local function setup_lsp_keymaps(client, bufnr)
            local opts = { buffer = bufnr, silent = true }

            -- Go to definition с fzf-lua
            vim.keymap.set("n", "gd", function()
                require('fzf-lua').lsp_definitions({ jump1 = true })
            end, vim.tbl_extend("force", opts, { desc = "Go to Definition" }))

            -- Go to declaration
            vim.keymap.set("n", "gD", function()
                require('fzf-lua').lsp_declarations({ jump1 = true })
            end, vim.tbl_extend("force", opts, { desc = "Go to Declaration" }))

            -- Go to implementation
            vim.keymap.set("n", "gi", function()
                require('fzf-lua').lsp_implementations({ jump1 = true })
            end, vim.tbl_extend("force", opts, { desc = "Go to Implementation" }))

            -- Go to type definition
            vim.keymap.set("n", "gt", function()
                require('fzf-lua').lsp_typedefs({ jump1 = true })
            end, vim.tbl_extend("force", opts, { desc = "Go to Type Definition" }))

            -- References
            vim.keymap.set("n", "gr", function()
                require('fzf-lua').lsp_references()
            end, vim.tbl_extend("force", opts, { desc = "Show References" }))

            -- Symbols
            vim.keymap.set("n", "<leader>ls", function()
                require('fzf-lua').lsp_document_symbols()
            end, vim.tbl_extend("force", opts, { desc = "Document Symbols" }))

            vim.keymap.set("n", "<leader>lS", function()
                require('fzf-lua').lsp_workspace_symbols()
            end, vim.tbl_extend("force", opts, { desc = "Workspace Symbols" }))

            -- Diagnostics
            vim.keymap.set("n", "<leader>ld", function()
                require('fzf-lua').diagnostics_document()
            end, vim.tbl_extend("force", opts, { desc = "Document Diagnostics" }))

            vim.keymap.set("n", "<leader>lD", function()
                require('fzf-lua').diagnostics_workspace()
            end, vim.tbl_extend("force", opts, { desc = "Workspace Diagnostics" }))

            -- Code actions
            vim.keymap.set("n", "<leader>ca", function()
                require('fzf-lua').lsp_code_actions()
            end, vim.tbl_extend("force", opts, { desc = "Code Actions" }))

            -- Incoming/Outgoing calls
            vim.keymap.set("n", "<leader>lci", function()
                require('fzf-lua').lsp_incoming_calls()
            end, vim.tbl_extend("force", opts, { desc = "Incoming Calls" }))

            vim.keymap.set("n", "<leader>lco", function()
                require('fzf-lua').lsp_outgoing_calls()
            end, vim.tbl_extend("force", opts, { desc = "Outgoing Calls" }))
            vim.keymap.set("n", "<leader>oi", function()
                require("vtsls").commands.organize_imports(bufnr)
            end, vim.tbl_extend("force", opts, { desc = "Organize Imports" }))

            vim.keymap.set("n", "<leader>ru", function()
                require("vtsls").commands.remove_unused_imports(bufnr)
            end, vim.tbl_extend("force", opts, { desc = "Remove Unused" }))
        end
        -- see a list of servers here: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
        local function eslint_config_exists()
            local eslintrc = vim.fn.glob("eslint.config.json", 0, 1)

            if not vim.tbl_isempty(eslintrc) then
                return true
            end

            if vim.fn.filereadable("package.json") then
                if vim.fn.json_decode(vim.fn.readfile("package.json"))["eslintConfig"] then
                    return true
                end
            end

            return false
        end
        local servers = {
            elmls = {},
            rust_analyzer = {},
            vtsls = {
                on_attach = function(client, bufnr)
                    setup_lsp_keymaps(client, bufnr)
                end,
            },
            astro = {},
            gleam = {},
            lua_ls = {
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim", "it", "describe", "before_each", "after_each" },
                        },
                    },
                },
            },
            biome = {
                on_attach = function(client, bufnr)
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.format({
                                filter = function(client)
                                    return client.name == "biome"
                                end,
                            })
                        end,
                    })
                end,
            },
            oxlint = {
                on_attach = function(client, bufnr)
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.format({
                                filter = function(client)
                                    return client.name == "oxlint"
                                end,
                            })
                        end,
                    })
                end,
            },
            eslint = {
                on_attach = function(client, bufnr)
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        buffer = bufnr,
                        command = "EslintFixAll",
                    })
                end,

                root_dir = function()
                    if not eslint_config_exists() then return nil end
                    return vim.fn.getcwd()
                end,
            },
            svelte = {},
            jsonls = {},
            elixirls = {},
            denols = {
                root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
                init_options = {
                    lint = true,
                    unstable = true, -- Enable unstable APIs (if needed)
                    suggest = {
                        imports = {
                            hosts = {
                                ["https://deno.land"] = true,
                            },
                        },
                    },
                },
            },
            gopls = {
                settings = {
                    gopls = {
                        analyses = {
                            unusedparams = true,
                        },
                        staticcheck = true,
                        gofumpt = true,
                    },
                },
            },
            tailwindcss = {
                settings = {
                    tailwindCSS = {
                        experimental = {
                            classRegex = {
                                { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
                                { "cx\\(([^)]*)\\)",  "(?:'|\"|`)([^']*)(?:'|\"|`)" },
                                { "cn\\(([^)]*)\\)",  "(?:'|\"|`)([^']*)(?:'|\"|`)" },
                            },
                        },
                    },
                },
            },
        }

        for server, config in pairs(servers) do
            -- passing config.capabilities to blink.cmp merges with the capabilities in your
            -- `server.capabilities, if you've defined it
            config.capabilities = blink.get_lsp_capabilities(config.capabilities)
            lspconfig[server].setup(config)
        end

        vim.diagnostic.config({
            virtual_text = true,
            signs = true,
            underline = true,
            update_in_insert = false,
            severity_sort = false,
        })

        local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.diagnostic.config()
        end

        vim.api.nvim_create_autocmd("CursorHold", {
            buffer = bufnr,
            callback = function()
                local opts = {
                    focusable = false,
                    close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
                    border = 'rounded',
                    source = 'always',
                    prefix = ' ',
                    scope = 'cursor',
                }
                vim.diagnostic.open_float(nil, opts)
            end
        })


        local on_attach = function(client, bufnr)
            vim.diagnostic.config({
                virtual_text = true,
                signs = true,
                underline = true,
                update_in_insert = false,
                severity_sort = false,
            })


            local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.diagnostic.config()
            end

            vim.api.nvim_create_autocmd("CursorHold", {
                buffer = bufnr,
                callback = function()
                    local opts = {
                        focusable = false,
                        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
                        border = 'rounded',
                        source = 'always',
                        prefix = ' ',
                        scope = 'cursor',
                    }
                    vim.diagnostic.open_float(nil, opts)
                end
            })

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
    end

}
