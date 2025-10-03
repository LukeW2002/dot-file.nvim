-- Fix: Convert port to number and add error handling
local port = tonumber(os.getenv('GDScript_Port')) or 6005
local pipe = '/tmp/godot.pipe'

-- Add error handling for the connection
local ok, cmd = pcall(vim.lsp.rpc.connect, '127.0.0.1', port)
if not ok then
  vim.notify("Failed to connect to Godot LSP on port " .. port .. ": " .. cmd, vim.log.levels.ERROR)
  return
end

-- Only try to start LSP if connection succeeded
local client_ok, client_id = pcall(vim.lsp.start, {
  name = 'Godot',
  cmd = cmd,
  root_dir = vim.fs.dirname(vim.fs.find({ 'project.godot', '.git' }, { upward = true })[1]),
  filetypes = { 'gdscript' },
  on_attach = function(client, bufnr)
    -- Set up LSP keybindings
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local opts = { noremap = true, silent = true }

    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)

    -- Start the server for Godot to connect back
    vim.api.nvim_command('echo serverstart("' .. pipe .. '")')
    vim.notify("Godot LSP attached to buffer " .. bufnr, vim.log.levels.INFO)
  end,
  on_init = function(client)
    vim.notify("Godot LSP initialized on port " .. port, vim.log.levels.INFO)
  end,
  on_exit = function(code, signal)
    vim.notify("Godot LSP exited with code: " .. code, vim.log.levels.WARN)
  end,
})

if not client_ok then
  vim.notify("Failed to start Godot LSP client: " .. tostring(client_id), vim.log.levels.ERROR)
end
