local map = vim.keymap.set

return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
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


        local lspconfig = require("lspconfig")
        require 'lspconfig'.gopls.setup({
            settings = {
                gopls = {
                    analyses = {
                        unusedparams = true,
                    },
                    staticcheck = true,
                    gofumpt = true,
                },
            },
        })
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

        --require 'lspconfig'.biome.setup {}
        require 'lspconfig'.rescriptls.setup {}

        -- require 'lspconfig'.jsonls.setup {
        -- filetypes = { "json" },
        -- init_options = {
        -- provideFormatter = true
        -- },
        -- commands = {
        -- Format = {
        -- function()
        -- vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line("$"), 0 })
        -- end
        -- }
        -- }
        -- }

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

        local function eslint_config_exists2()
            -- Проверяем разные файлы конфигурации
            local config_files = {
                ".eslintrc.js",
                ".eslintrc.json",
                ".eslintrc.yaml",
                ".eslintrc.yml",
                "eslint.config.js",
                "eslint.config.json"
            }

            for _, file in ipairs(config_files) do
                if vim.fn.filereadable(file) == 1 then
                    print(file)
                    return true
                end
            end

            -- Проверяем package.json
            if vim.fn.filereadable("package.json") == 1 then
                local ok, package_json = pcall(vim.fn.json_decode, vim.fn.readfile("package.json"))
                if ok and package_json.eslintConfig then
                    return true
                end
            end

            return false
        end

        lspconfig.rust_analyzer.setup({
            on_attach = on_attach,
            settings = {
                ["rust-analyzer"] = {
                    imports = {
                        granularity = {
                            group = "module",
                        },
                        prefix = "self",
                    },
                    cargo = {
                        buildScripts = {
                            enable = true,
                        },
                    },
                    procMacro = {
                        enable = true
                    },
                }
            }
        })

        require('lspconfig').rescriptls.setup {}

        -- local eslint = {
        -- lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
        -- lintStdin = true,
        -- lintFormats = { "%f:%l:%c: %m" },
        -- lintIgnoreExitCode = true,
        -- formatCommand =
        -- "eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}",
        -- formatStdin = true
        -- }

        -- lspconfig.efm.setup {
        -- on_attach = function(client)
        -- client.resolved_capabilities.document_formatting = true
        -- client.resolved_capabilities.goto_definition = false
        -- lspconfig.set_lsp_config(client)
        -- end, root_dir = function()
        -- if not eslint_config_exists() then return nil end
        -- return vim.fn.getcwd()
        -- end, settings = { languages = { javascript = { eslint }, javascriptreact = { eslint }, ["javascript.jsx"] = { eslint }, typescript = { eslint }, ["typescript.tsx"] = { eslint }, typescriptreact = { eslint } } }, filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescript.tsx", "typescriptreact" }, }

        require('lspconfig').eslint.setup({
            root_dir = function()
                if not eslint_config_exists() then return nil end
                return vim.fn.getcwd()
            end,
            on_attach = on_attach,
            capabilities = capabilities,
            settings = {

            }

        })

        local servers = { "vtsls", "eslint", "tailwindcss", "html", };
        for _, lsp in ipairs(servers) do
            require('lspconfig')[lsp].setup({
                on_attach = on_attach,
                capabilities = capabilities,
            })
        end
    end
}
