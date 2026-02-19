-- Твой основной treesitter файл
return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects", -- добавь эту строку
	},
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = { "typescript", "javascript", "lua", "json" },
			highlight = { enable = true },
			indent = { enable = true },
			-- Твой incremental selection
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "gnn",
					node_incremental = "grn",
					scope_incremental = "grc",
					node_decremental = "grm",
				},
			},
			-- ДОБАВЬ ЭТО:
			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["aa"] = "@parameter.outer",
						["ia"] = "@parameter.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
					},
				},
				move = {
					enable = true,
					set_jumps = true,
					goto_next_start = {
						["]f"] = "@function.outer",
						["]a"] = "@parameter.inner",
					},
					goto_previous_start = {
						["[f"] = "@function.outer",
						["[a"] = "@parameter.inner",
					},
				},
			},
		})
	end,
}
