local dap = require('dap')
local dapui = require('dapui')

-- DAP UI setup
dapui.setup({
  icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
  mappings = {
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  layouts = {
    {
      elements = {
        { id = "scopes", size = 0.25 },
        "breakpoints",
        "stacks",
        "watches",
      },
      size = 40, -- 40 columns
      position = "left",
    },
    {
      elements = {
        "repl",
        "console",
      },
      size = 0.25, -- 25% of total lines
      position = "bottom",
    },
  },
})
dap.adapters.gdb = {
  type = 'executable',
  command = 'gdb',
  args = { "-i", "dap" }
}
dap.adapters.codelldb = {
  type = 'server',
  port = "${port}",
  executable = {
    command = vim.fn.stdpath("data") .. '/mason/packages/codelldb/extension/adapter/codelldb',
    args = {"--port", "${port}"},
  }
}

dap.configurations.cpp = {
  {
    name = "Launch File",
    type = "codelldb",
    request = "launch",
    stopOnEntry = false,
    program = "${workspaceFolder}/${fileBasenameNoExtension}",
    -- Advanced features that CodeLLDB provides:
    expressions = 'native',  -- Better expression evaluation
    terminal = 'integrated'  -- Uses Neovim's terminal
  }
}
dap.configurations.c = {
  {
    name = "Remote Debug (gdbserver)",
    type = "gdb",
    request = "attach",
    cwd = vim.fn.getcwd(),
    target = "192.168.0.31:3000", -- Replace with your Pi's IP
    remote = true,
    stopAtEntry = true,
    runInTerminal = false,
    setupCommands = {
      {
        text = "-enable-pretty-printing",
        description = "enable pretty printing",
        ignoreFailures = false
      },
      {
        text = "set sysroot remote:/",
        description = "set remote sysroot",
        ignoreFailures = false
      },
      {
        text = "set print array on",
        description = "Enable array printing",
        ignoreFailures = false
      },
      {
        text = "set print pretty on",
        description = "Enable pretty printing",
        ignoreFailures = false
      },
      {
        text = "set print elements 100",
        description = "Set array printing limit",
        ignoreFailures = false
      }
    }
  },
  {
    name = "Launch Local Program",
    type = "gdb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopAtEntry = true,
    setupCommands = {
      {
        text = string.format('directory %s', vim.fn.getcwd()),
        description = 'set source path',
        ignoreFailures = false

      },
      {
        text = "-enable-pretty-printing",
        description = "enable pretty printing",
        ignoreFailures = false
      },
      {
        text = "set print array on",
        description = "Enable array printing",
        ignoreFailures = false
      },
      {
        text = "set print pretty on",
        description = "Enable pretty printing",
        ignoreFailures = false
      },
      {
        text = "set print elements 100",
        description = "Set array printing limit",
        ignoreFailures = false
      }
    }
  }

}

local widgets = require('dap.ui.widgets')


vim.keymap.set('n', '<Leader>dp', function()
    if not dap.session() then
        vim.notify("No active debug session", vim.log.levels.ERROR)
        return
    end
    
    -- Create a popup window to enter array length
    local length = vim.fn.input('Array length to inspect: ')
    if length == '' then return end
    
    -- Get variable under cursor
    local expr = vim.fn.expand('<cexpr>')
    if expr == '' then
        expr = vim.fn.expand('<cword>')
    end
    
    -- Create watch expression for array
    dap.eval(string.format('*%s@%s', expr, length), {}, function(err, resp)
        if err then
            vim.notify(string.format('Error: %s', err), vim.log.levels.ERROR)
            return
        end
        if resp == nil or resp.result == nil then
            vim.notify('No result returned', vim.log.levels.WARN)
            return
        end
        -- Open floating window with result
        widgets.hover(resp.result)
    end)
end, { desc = 'Inspect array under cursor' })


local keymap_opts = { noremap = true, silent = true }
vim.keymap.set('n', '<F5>', function() dap.continue() end, keymap_opts)
vim.keymap.set('n', '<F10>', function() dap.step_over() end, keymap_opts)
vim.keymap.set('n', '<F11>', function() dap.step_into() end, keymap_opts)
vim.keymap.set('n', '<F12>', function() dap.step_out() end, keymap_opts)
vim.keymap.set('n', '<Leader>b', function() dap.toggle_breakpoint() end, keymap_opts)
vim.keymap.set('n', '<Leader>dr', function() dap.repl.open() end, keymap_opts)
vim.keymap.set('n', '<Leader>q', function() require('dap').terminate() end, { noremap = true, silent = true })

require('telescope').load_extension('dap')
vim.keymap.set('n', '<leader>df', ':Telescope dap frames<CR>', keymap_opts)
vim.keymap.set('n', '<leader>db', ':Telescope dap list_breakpoints<CR>', keymap_opts)

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

require("nvim-dap-virtual-text").setup {
    enabled = true,
    enabled_commands = true,
    highlight_changed_variables = true,
    highlight_new_as_changed = false,
    show_stop_reason = true,
    commented = false,
    virt_text_pos = 'eol',
    all_frames = false,
    virt_lines = false,
    virt_text_win_col = nil
}
