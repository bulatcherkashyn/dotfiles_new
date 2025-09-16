vim.keymap.set("n", "<leader>ff", require('fzf-lua').files, { desc = "Fzf Files" })
vim.keymap.set("n", "<leader>fg", require('fzf-lua').live_grep, { desc = "Fzf Grep" })
vim.keymap.set("n", "<leader>fb", require('fzf-lua').buffers, { desc = "Fzf Buffers" })
vim.keymap.set("n", "<leader>fh", require('fzf-lua').help_tags, { desc = "Fzf Help" })
