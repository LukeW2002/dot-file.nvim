-- Config

-- Vimspector options
vim.cmd([[
let g:vimspector_sidebar_width = 85
let g:vimspector_bottombar_height = 15
let g:vimspector_terminal_maxwidth = 70
]])

-- Treesitter folding 
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'

vim.opt_local.scrolloff = 5
vim.wo.foldminlines = 4

-- Completeop
vim.opt.completeopt = {'menuone', 'noselect', 'noinsert'}
vim.opt.shortmess = vim.opt.shortmess + { c = true}
vim.api.nvim_set_option('updatetime', 300) 

-- theme configuration
vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme gruvbox]])

-- Vimtex configuration
vim.g.vimtex_view_method = 'skim'
vim.g.tex_flavor = 'latex'
vim.g.vimtex_quickfix_mode = 0
vim.g.vimtex_compiler_method = "pdftex"

-- UltiSnips configuration
vim.g.UltiSnipsExpandTrigger = "<tab>"
vim.g.UltiSnipsJumpForwardTrigger = "<tab>"
vim.g.UltiSnipsJumpBackwardTrigger = "<s-tab>"

-- SuperTab configuration
vim.g.SuperTabDefaultCompletionType = '<C-n>'

vim.opt.syntax = "enable"
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.ignorecase = true
vim.opt.cindent = true
vim.opt.number = true
vim.opt.termguicolors = true
vim.opt.relativenumber = true
vim.opt.spell = true
vim.opt.spelllang = "en_gb"

vim.api.nvim_create_autocmd("FileType", {
  pattern = "txt",
  command = "setlocal textwidth=80",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.cmd("WordMode")
    vim.opt_local.conceallevel = 2
    vim.opt_local.textwidth = 0
  end,
})

-- Writing
vim.api.nvim_create_user_command("WordMode", function() 
    vim.api.nvim_buf_set_keymap(0, 'n', 'j', 'gj', { noremap = true })
    vim.api.nvim_buf_set_keymap(0, 'n', 'k', 'gk', { noremap = true })
    -- Enable soft wrapping
    vim.opt_local.wrap = true
    -- Break lines at word boundaries
    vim.opt_local.linebreak = true
    -- Preserve indentation when wrapping
    vim.opt_local.breakindent = true
    -- Show as much of the last line as possible
    vim.opt_local.display = "lastline"
    -- Keep at least one line visible above/below the cursor
    vim.opt_local.scrolloff = 5
    -- Disable line numbers for a cleaner look
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    -- Enable spell checking
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en_gb"
 end, {}
)

vim.api.nvim_create_autocmd("VimResized", {
  pattern = "*",
  callback = function()
    if vim.fn.exists(":Goyo") == 2 then  -- Check if Goyo is available
      vim.cmd("silent! Goyo")  -- Turn off Goyo
      vim.cmd("silent! Goyo")  -- Turn on Goyo again
    end
  end,
})


-- LOOKz
vim.o.background = "dark"

--vim.cmd([[colorscheme tokyonight-night]])
-- vim.cmd([[colorscheme catppuccin-mocha]])
-- vim.cmd([[colorscheme rose-pine]])
 vim.cmd([[colorscheme kanagawa]])
-- vim.cmd([[colorscheme nightfox]])
-- vim.cmd([[colorscheme dracula]])

vim.api.nvim_create_user_command('Tokyo', function() vim.cmd('colorscheme tokyonight-night') end, {})
vim.api.nvim_create_user_command('Cat', function() vim.cmd('colorscheme catppuccin-mocha') end, {})
vim.api.nvim_create_user_command('Rose', function() vim.cmd('colorscheme rose-pine') end, {})
vim.api.nvim_create_user_command('Kana', function() vim.cmd('colorscheme kanagawa') end, {})
vim.api.nvim_create_user_command('Night', function() vim.cmd('colorscheme nightfox') end, {})
vim.api.nvim_create_user_command('Drac', function() vim.cmd('colorscheme dracula') end, {})
vim.api.nvim_create_user_command('Gruv', function() vim.cmd('colorscheme gruvbox') end, {})

local themes = {
  'tokyonight-night',
  'catppuccin-mocha', 
  'rose-pine',
  'kanagawa',
  'nightfox',
  'dracula',
  'gruvbox'
}

local current_theme = 1
vim.keymap.set('n', '<leader>th', function()
  current_theme = current_theme % #themes + 1
  vim.cmd('colorscheme ' .. themes[current_theme])
  vim.notify('Theme: ' .. themes[current_theme], vim.log.levels.INFO)
end, { desc = 'Cycle themes' })
