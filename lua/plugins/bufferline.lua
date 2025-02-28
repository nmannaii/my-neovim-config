return {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    event = "VeryLazy",
    opts = {
        options = {
            diagnostics = "nvim_lsp",
            always_show_bufferline = false,
            diagnostics_indicator = function(count, level, _, _)
                local icon = level:match("error") and " " or " "
                return " " .. icon .. count
            end,
        },
    },
    config = function(_, opts)
        require("bufferline").setup(opts)
    end,
}
