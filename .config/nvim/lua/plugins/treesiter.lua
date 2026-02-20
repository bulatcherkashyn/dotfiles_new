-- Твой основной treesitter файл
return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local configs = require("nvim-treesitter.config")

        configs.setup({
            ensure_installed = { "dockerfile", "dot", "lua", "vim", "vimdoc", "rust", "javascript", "typescript", "tsx", "markdown", "go", "toml", "html" },
            sync_install = true,
            highlight = { "dockerfile", "dot", "lua", "vim", "vimdoc", "rust", "javascript", "typescript", "tsx", "markdown", "go", "toml", "html" },
            indent = {
                enable = true,
                disable = { "python", "yaml" }
            },
        })
    end
}
