local function CsharpDebugConfig(dap)
    dap.adapters.coreclr = {
        type = 'executable',
        command = vim.fn.exepath("netcoredbg"),
        args = {'--interpreter=vscode'},
    }
    dap.configurations.cs = {
        {
            type = "coreclr",
            name = "launch - netcoredbg",
            request = "launch",
            program = function()
                return vim.fn.input('Path to dll', vim.fn.getcwd() .. '\\bin\\Debug\\net8.0', 'file')
            end,
        },
    }
end

return {
    "mfussenegger/nvim-dap",
    dependencies = {
        'nvim-neotest/nvim-nio',
        'rcarriga/nvim-dap-ui'
    },
    config = function ()
        local dap, dapui = require("dap"), require("dapui")
        -- setup csharp dap
        CsharpDebugConfig(dap)
        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
        end
        vim.keymap.set('n', '<Leader>db', function() dap.toggle_breakpoint() end, {desc = "Toggle breakpoint"})
        vim.keymap.set('n', '<Leader>dc', function() dap.continue() end, {desc = "Continue"})
    end
}

