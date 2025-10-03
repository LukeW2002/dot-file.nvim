 local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
 if not vim.loop.fs_stat(lazypath) then
   vim.fn.system({
     'git', 'clone', '--filter=blob:none',
     'https://github.com/folke/lazy.nvim', lazypath
   })
 end
 vim.opt.rtp:prepend(lazypath)

 require('lazy').setup(require('plugins'))
	require('settings')
	require('keymaps')
	require("mason").setup()
	require('lsp')
  --require('gdscript')
	require('dap').set_log_level('TRACE')
	require('dap-config')
	require'colorizer'.setup()

 vim.deprecate = function() end
