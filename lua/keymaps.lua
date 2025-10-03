-- Vimspector

vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>E', ':Neotree reveal<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>ft', ':Telescope file_browser<CR>', { noremap = true, silent = true })
local godot = require('godot-runner')

-- Godot project management
vim.keymap.set('n', '<leader>rg', godot.run_project, { desc = 'Run Godot Project' })
vim.keymap.set('n', '<F6>', godot.run_current_scene, { desc = 'Run Current Scene' })
vim.keymap.set('n', '<leader>ge', godot.open_editor, { desc = 'Open Godot Editor' })
vim.keymap.set('n', '<leader>gk', godot.kill_godot, { desc = 'Kill Godot Processes' })
vim.keymap.set('n', '<leader>gx', godot.export_project, { desc = 'Export Godot Project' })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "gdscript",
  callback = function()
    local opts = { noremap = true, silent = true, buffer = 0 }
    vim.keymap.set('n', '<leader>r', godot.run_project, opts)
    vim.keymap.set('n', '<leader>R', godot.run_current_scene, opts)
    vim.keymap.set('n', '<leader>go', godot.open_editor, opts)
  end,
})

--Auto complete brackets
vim.api.nvim_set_keymap('i', '"', '""<left>', {noremap = true})

vim.api.nvim_set_keymap('i', "'", "''<left>", {noremap = true})
vim.api.nvim_set_keymap('i', '(', '()<left>', {noremap = true})
vim.api.nvim_set_keymap('i', '[', '[]<left>', {noremap = true})
vim.api.nvim_set_keymap('i', '{', '{}<left>', {noremap = true})
vim.api.nvim_set_keymap('i', '{<CR>', '{<CR>}<ESC>O', {noremap = true})
vim.api.nvim_set_keymap('i', '{;<CR>', '{<CR>};<ESC>O', {noremap = true})

--Copy and Paste
vim.api.nvim_set_keymap('v', '<S-C-c>', '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-C-v>', '"+p', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<S-C-v>', '<C-r>+', { noremap = true, silent = true })

--Telescope
local telescope = require('telescope.builtin')

vim.keymap.set('n', '<leader>ff', telescope.find_files, {})
vim.keymap.set('n', '<leader>fg', telescope.live_grep, {})
vim.keymap.set('n', '<leader>fb', telescope.buffers, {})
vim.keymap.set('n', '<leader>fh', telescope.help_tags, {})

vim.keymap.set('n', '<leader>fs', telescope.lsp_document_symbols, {})
vim.keymap.set('n', '<leader>fr', telescope.lsp_references, {})


--Txt
vim.api.nvim_create_autocmd("FileType", {
  pattern = "txt",
  callback = function()
    vim.api.nvim_buf_set_keymap(0, 'n', '<leader>g', ':Goyo<CR>', { noremap = true, silent = true })
  end
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "txt",
  callback = function()
    vim.api.nvim_buf_set_keymap(0, 'n', 'j', 'gj', { noremap = true })
    vim.api.nvim_buf_set_keymap(0, 'n', 'k', 'gk', { noremap = true })
  end
})

-- Dap
vim.api.nvim_create_user_command("PiDebug", function(opts)
    require('dap').configurations.cpp[1].gdbserver = "192.168.0.31:3000"
    require('dap').configurations.cpp[1].program = opts.args
    require('dap').continue()
end, {nargs = 1})

--local function correct_spelling()
--    vim.cmd('normal! [s')
--    vim.cmd('normal! z=1')
--    vim.cmd('normal! <CR>')
--end
--
--vim.keymap.set('n', '<leader>z', correct_spelling, { noremap = true, silent = true })
--
--
-- Diagnostic keymaps
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic error messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic quickfix list' })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })

-- Configure diagnostic appearance globally
vim.diagnostic.config({
  virtual_text = {
    enabled = true,
    prefix = '●',
    spacing = 4,
    severity = { min = vim.diagnostic.severity.WARN }, -- Only show warnings and errors
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = ' ',
      [vim.diagnostic.severity.WARN] = ' ',
      [vim.diagnostic.severity.HINT] = ' ',
      [vim.diagnostic.severity.INFO] = ' ',
    }
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = 'rounded',
    source = 'always',
  },
})
