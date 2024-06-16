return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local capabilities = cmp_nvim_lsp.default_capabilities()
		vim.cmd([[autocmd BufWritePre * lua vim.lsp.buf.format()]])
		require('lspconfig').lua_ls.setup({
			capabilities = capabilities,
			settings = {
				Lua = {
					diagnostics = {
						globals = { 'vim' }
					}
				}
			}
		})

		require('lspconfig').tsserver.setup({
			capabilities = capabilities,
		})
		require('lspconfig').eslint.setup({
			capabilities = capabilities,
		})
	end
}
