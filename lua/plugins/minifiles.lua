return {
    'echasnovski/mini.files',
    version = '*',
    config = function ()
        local miniFiles = require('mini.files')
        miniFiles.setup({
            windows = {
                preview = true,
                width_focus = 30,
                width_preview = 30
            }
        })
        vim.keymap.set('n', '<leader>e', function() miniFiles.open(vim.api.nvim_buf_get_name(0), true) end)
    end
}
