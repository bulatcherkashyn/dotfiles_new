return {
	"kevinhwang91/nvim-ufo",
	dependencies = "kevinhwang91/promise-async",
	config = function()
		vim.o.foldcolumn = "1" -- '0' is not bad
		vim.opt.foldmethod = "expr"
		vim.opt.foldexpr = "v:lua.require'ufo'.getFolds(bufnr, winid)" -- не нужно, ufo сам
		vim.opt.foldlevel = 99
		vim.opt.foldlevelstart = 99
		vim.opt.foldenable = true -- с ufo можно включить

		require("ufo").setup({
			provider_selector = function()
				return { "treesitter", "indent" } -- treesitter, fallback на indent
			end,
		})

		-- удобные кейбинды
		vim.keymap.set("n", "zR", require("ufo").openAllFolds)
		vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
		vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
		vim.keymap.set("n", "K", function()
			local winid = require("ufo").peekFoldedLinesUnderCursor()
			if not winid then
				vim.lsp.buf.hover() -- если нет fold — обычный hover
			end
		end)
	end,
}
