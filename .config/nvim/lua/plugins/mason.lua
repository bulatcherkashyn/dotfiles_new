return {
	"neovim/nvim-lspconfig",
    dependencies = {
		"williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/nvim-cmp",
		"hrsh7th/cmp-nvim-lua",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"saadparwaiz1/cmp_luasnip",
		"L3MON4D3/LuaSnip",
      },
    config = function()
	local cmp = require('cmp')
	cmp.setup({
	  sources = {
		{name = 'nvim_lsp'},
	  },
	  completion = {
		autocomplete = false
	  },
	  window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	  mapping = {
		['<C-y>'] = cmp.mapping.confirm({select = false}),
		['<C-e>'] = cmp.mapping.abort(),
		['<Up>'] = cmp.mapping.select_prev_item({behavior = 'select'}),
		['<Down>'] = cmp.mapping.select_next_item({behavior = 'select'}),
		['<C-p>'] = cmp.mapping(function()
		  if cmp.visible() then
			cmp.select_prev_item({behavior = 'insert'})
		  else
			cmp.complete()
		  end
		end),
		['<C-Space>'] = cmp.mapping(function()
			if not cmp.visible() then
				cmp.complete()
			else
				cmp.abort()
			end
		end),
		['<C-n>'] = cmp.mapping(function()
		  if cmp.visible() then
			cmp.select_next_item({behavior = 'insert'})
		  else
			cmp.complete()
		  end
		end),
	  },
	  snippet = {
		expand = function(args)
		  require('luasnip').lsp_expand(args.body)
		end,
	  },
	})
	cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
  })

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
	  ensure_installed = {'lua_ls', 'eslint', 'tsserver', 'rust_analyzer'},
	  handlers = {
	    function(server_name)
	      require('lspconfig')[server_name].setup({})
	    end,
        lua_ls = function()
            require('lspconfig').lua_ls.setup({
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { 'vim' }
                        }
                    }
                }
            })
        end
	  },
	})
    end
}
