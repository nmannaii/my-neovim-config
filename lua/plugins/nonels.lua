return {
    "nvimtools/none-ls.nvim",
    dependencies = {
        "nvimtools/none-ls-extras.nvim"
    },
    config = function ()
        local null_ls = require("null-ls")
        -- Helper to conditionally register eslint handlers only if eslint is
        -- config. If eslint is not configured for a project, it just fails.
        local function has_eslint_config(utils)
            return utils.root_has_file({
                ".eslintrc",
                ".eslintrc.cjs",
                ".eslintrc.js",
                ".eslintrc.json",
                "eslint.config.cjs",
                "eslint.config.js",
                "eslint.config.mjs",
            })
        end
        null_ls.setup({
            sources = {
                require("none-ls.code_actions.eslint_d").with({ condition = has_eslint_config }),
				require("none-ls.diagnostics.eslint_d").with({ condition = has_eslint_config }),
            },
        })
    end
}
