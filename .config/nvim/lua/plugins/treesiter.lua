return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function ()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
          ensure_installed = { "dockerfile", "dot", "lua", "vim", "vimdoc", "rust", "javascript", "typescript", "html" },
          sync_install = false,
          highlight = { enable = true },
          indent = {
              enable = true,
	      disable = {"python", "yaml"}
		  },
	})
    end
}
