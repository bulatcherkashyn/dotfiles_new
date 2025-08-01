return {
    "nvim-neotest/neotest",
    ft = { "typescript", "javascript" },
    dependencies = {
        "nvim-neotest/neotest-jest",
    },
    opts = function()
        return {
            -- your neotest config here
            adapters = {
                require "neotest-jest",
            },
        }
    end,
    config = function(_, opts)
        -- get neotest namespace (api call creates or returns namespace)
        local neotest_ns = vim.api.nvim_create_namespace "neotest"
        vim.diagnostic.config({
            virtual_text = {
                format = function(diagnostic)
                    local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
                    return message
                end,
            },
        }, neotest_ns)
        require("neotest").setup(opts)
    end,
}
