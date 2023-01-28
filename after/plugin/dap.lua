local dap = require('dap')

dap.adapters.lldb = {
    type = 'executable',
    command = '/usr/bin//lldb-vscode',
    name = 'lldb',
}

dap.configurations.cpp = {
    {
        name = 'Launch',
        type = 'lldb',
        request = 'launch',
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopEntry = false,
        args = {},
    },
}

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

dap.configurations.node2 = {
    type = 'executable',
    command = 'node-debug2-adapter',
    args = {},
}

dap.configurations.javascript = {
    {
        name = 'Launch',
        type = 'node2',
        request = 'launch',
        program = '${file}',
        cmd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = 'inspector',
        console = 'integratedTerminal',
    },
    {
        name = 'Attach to process',
        type = 'node2',
        request = 'attach',
        restart = true,
        processId = require('dap.utils').pick_process,
    },
}

local dapui = require('dapui')
dapui.setup()
