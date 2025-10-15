return {
	"nvim-neotest/neotest",
	ft = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
	dependencies = {
		"nvim-neotest/nvim-nio", -- ✅ Добавлено: обязательная зависимость
		"nvim-lua/plenary.nvim", -- ✅ Добавлено: обязательная зависимость
		"antoinemadec/FixCursorHold.nvim", -- ✅ Добавлено: для стабильности
		"nvim-treesitter/nvim-treesitter", -- ✅ Добавлено: для парсинга тестов
		"nvim-neotest/neotest-jest",
	},
	opts = function()
		return {
			adapters = {
				require("neotest-jest")({
					jestCommand = "npm test --", -- ✅ Добавлено: команда Jest
					jestConfigFile = "jest.config.js", -- ✅ Добавлено: конфиг файл
					env = { CI = true }, -- ✅ Добавлено: окружение
					cwd = function() -- ✅ Добавлено: рабочая директория
						return vim.fn.getcwd()
					end,
				}),
			},
			-- ✅ Добавлено: настройки статуса
			status = {
				enabled = true,
				virtual_text = true,
				signs = true,
			},
			-- ✅ Добавлено: настройки иконок
			icons = {
				passed = "",
				running = "",
				failed = "",
				skipped = "",
				unknown = "",
			},
			-- ✅ Добавлено: настройки floating окон
			floating = {
				border = "rounded",
				max_height = 0.6,
				max_width = 0.6,
			},
			-- ✅ Добавлено: настройки summary
			summary = {
				enabled = true,
				follow = true,
				expand_errors = true,
			},
			-- ✅ Добавлено: настройки output
			output = {
				enabled = true,
				open_on_run = true,
			},
		}
	end,
	config = function(_, opts)
		-- get neotest namespace (api call creates or returns namespace)
		local neotest_ns = vim.api.nvim_create_namespace("neotest")
		vim.diagnostic.config({
			virtual_text = {
				format = function(diagnostic)
					local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
					return message
				end,
			},
		}, neotest_ns)

		require("neotest").setup(opts)

		-- ✅ Добавлено: Keybindings
		local neotest = require("neotest")

		vim.keymap.set("n", "<leader>tt", function()
			neotest.run.run()
		end, { desc = "Run nearest test" })

		vim.keymap.set("n", "<leader>tf", function()
			neotest.run.run(vim.fn.expand("%"))
		end, { desc = "Run file tests" })

		vim.keymap.set("n", "<leader>ta", function()
			neotest.run.run(vim.fn.getcwd())
		end, { desc = "Run all tests" })

		vim.keymap.set("n", "<leader>ts", function()
			neotest.summary.toggle()
		end, { desc = "Toggle test summary" })

		vim.keymap.set("n", "<leader>to", function()
			neotest.output.open({ enter = true })
		end, { desc = "Show test output" })

		vim.keymap.set("n", "<leader>tO", function()
			neotest.output_panel.toggle()
		end, { desc = "Toggle output panel" })

		vim.keymap.set("n", "<leader>tw", function()
			neotest.watch.toggle()
		end, { desc = "Toggle watch mode" })

		vim.keymap.set("n", "[t", function()
			neotest.jump.prev({ status = "failed" })
		end, { desc = "Previous failed test" })

		vim.keymap.set("n", "]t", function()
			neotest.jump.next({ status = "failed" })
		end, { desc = "Next failed test" })
	end,
}
