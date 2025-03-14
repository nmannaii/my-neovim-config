return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "stevearc/conform.nvim",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "j-hui/fidget.nvim",
        "saghen/blink.cmp",
        "seblyng/roslyn.nvim",
        "nvim-telescope/telescope.nvim",
        "pmizio/typescript-tools.nvim"
    },

    config = function()
        local capabilities = require("blink.cmp").get_lsp_capabilities()
        require("conform").setup({
            formatters_by_ft = {
            }
        })
        require("fidget").setup({
            notification = {
                window = {
                    winblend = 0
                }
            }
        })
        require("mason").setup({
            registries = { "github:crashdummyy/mason-registry", "github:mason-org/mason-registry" },
        })
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "angularls",
                "eslint",
                "pyright",
                "emmet_language_server",
                "cssls",
                "css_variables",
            },
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,

                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = { version = "Lua 5.1" },
                                diagnostics = {
                                    globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                                }
                            }
                        }
                    }
                end,
            }
        })
        require("roslyn").setup()
        require("typescript-tools").setup({
            settings = {
                tsserver_plugins = {
                    "@angular/language-server"
                },
            }
        })
        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })

        vim.api.nvim_create_autocmd('LspAttach', {
            desc = 'LSP actions',
            callback = function(event)
                local opts = { buffer = event.buf }

                vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
                vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
                vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
                vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
                vim.keymap.set('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
            end,
        })
    end
}
