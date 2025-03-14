--- Rebuilds the project before starting the debug session
---@param co thread
local function rebuild_project(co, path)
  local spinner = require("easy-dotnet.ui-modules.spinner").new()
  spinner:start_spinner("Building")
  vim.fn.jobstart(string.format("dotnet build %s", path), {
    on_exit = function(_, return_code)
      if return_code == 0 then
        spinner:stop_spinner("Built successfully")
      else
        spinner:stop_spinner("Build failed with exit code " .. return_code, vim.log.levels.ERROR)
        error("Build failed")
      end
      coroutine.resume(co)
    end,
  })
  coroutine.yield()
end
local function csharp_debugger_setup(dap)
    local dotnet = require("easy-dotnet")
    local debug_dll = nil

    local function ensure_dll()
        if debug_dll ~= nil then
            return debug_dll
        end
        local dll = dotnet.get_debug_dll()
        debug_dll = dll
        return dll
    end

    dap.configurations["cs"] = {
        {
            type = "coreclr",
            name = "launch - netcoredbg",
            request = "launch",
            env = function()
                local dll = ensure_dll()
                local vars = dotnet.get_environment_variables(dll.project_name, dll.relative_project_path)
                return vars or nil
            end,
            program = function()
                local dll = ensure_dll()
                local co = coroutine.running()
                rebuild_project(co, dll.project_path)
                return dll.relative_dll_path
            end,
            cwd = function()
                local dll = ensure_dll()
                return dll.relative_project_path
            end,

        }
    }
    dap.listeners.before['event_terminated']['easy-dotnet'] = function()
        debug_dll = nil
    end
    dap.adapters.coreclr = {
        type = "executable",
        command = "netcoredbg",
        args = { "--interpreter=vscode" },
    }
end
return {
    "mfussenegger/nvim-dap",
    dependencies = {
        'nvim-neotest/nvim-nio',
        'rcarriga/nvim-dap-ui',
    },
    config = function ()
        local dap, dapui = require("dap"), require("dapui")
        dapui.setup()
        -- setup csharp dap
        csharp_debugger_setup(dap)
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

