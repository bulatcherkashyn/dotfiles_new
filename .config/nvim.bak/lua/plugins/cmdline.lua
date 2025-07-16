return {
    "VonHeikemen/fine-cmdline.nvim",
    dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-telescope/telescope.nvim"
    },
    config = function()
        require('fine-cmdline').setup({
            cmdline = {
                enable_keymaps = true,
                smart_history = true,
                prompt = ': '
            },
            popup = {
                position = {
                    row = '10%',
                    col = '50%',
                },
                size = {
                    width = '30%',
                },
                border = {
                    style = 'rounded',
                },
                win_options = {
                    winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
                },
            },
            hooks = {
                before_mount = function(input)
                    -- code
                end,
                after_mount = function(input)
                    -- code
                end,
                set_keymaps = function(imap, feedkeys)
                    local fn = require('fine-cmdline').fn

                    imap('<M-k>', fn.up_search_history)
                    imap('<M-j>', fn.down_search_history)
                    imap('<Up>', fn.up_history)
                    imap('<Down>', fn.down_history)
                end
            }
        })
    end
}
