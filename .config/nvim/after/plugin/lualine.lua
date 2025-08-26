vim.keymap.set('n', '<leader>lh', function()
    require('lualine').hide()
end)

vim.keymap.set('n', '<leader>ls', function()
    require('lualine').hide({ unhide = true })
end)
