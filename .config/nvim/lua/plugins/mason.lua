return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
	},
	config = function()
		require('mason').setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗"
				}
			}
		})
		require('mason-lspconfig').setup({
			-- Replace the language servers listed here
			-- with the ones you want to install
			ensure_installed = { 'lua_ls', 'eslint', 'tsserver', 'rust_analyzer', 'html' },
		})
	end
}
