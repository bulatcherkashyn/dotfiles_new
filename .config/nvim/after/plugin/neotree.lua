vim.keymap.set('n', '<leader>nt', function()
    vim.cmd.Neotree('toggle')
end, { desc = "Toggle Neotree" })
