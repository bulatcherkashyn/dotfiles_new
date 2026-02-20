return {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    dependencies = {
        "rafamadriz/friendly-snippets",
    },
    config = function()
        local ls = require("luasnip")
        local s = ls.snippet                           -- добавь эту строку
        local t = ls.text_node                         -- добавь эту строку
        local i = ls.insert_node                       -- д
        ls.setup({
            history = true,                            -- можно переключаться между placeholder'ами назад
            updateevents = "TextChanged,TextChangedI", -- обновлять динамические узлы
            enable_autosnippets = true,
        })

        vim.keymap.set({ "i", "s" }, "<C-k>", function()
            if ls.expand_or_jumpable() then
                ls.expand_or_jump()
            end
        end, { silent = true, desc = "Expand snippet or jump" })

        -- Возврат назад - Ctrl+J
        vim.keymap.set({ "i", "s" }, "<C-j>", function()
            if ls.jumpable(-1) then
                ls.jump(-1)
            end
        end, { silent = true, desc = "Jump back" })

        ls.add_snippets("typescript", {
            s("cl", {
                t("console.log("),
                i(1, "value"),
                t(");"),
            }),
        })
        ls.add_snippets("lua", {
            s("hello", {
                t("hello world"),
            }),
        })
    end,
}
