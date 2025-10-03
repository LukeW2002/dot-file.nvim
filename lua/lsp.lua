local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local opts = { noremap=true, silent=true }

  -- Jump to definition and references
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)

  -- Hover documentation
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)

  -- Symbol renaming
  buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)

  -- Code action
  buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
end


local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

lspconfig.clangd.setup{
    cmd = {
        "clangd",
        "--background-index",
        "--suggest-missing-includes",
        "--clang-tidy",
        "--completion-style=detailed",
        "--fallback-style=llvm",
        "--function-arg-placeholders",
        "--query-driver=/usr/bin/clang,/usr/bin/clang++,/opt/homebrew/bin/*,/opt/homebrew/opt/llvm/bin/*",
        "--query-driver=/usr/bin/gcc",
        "--all-scopes-completion",
        "--header-insertion=never",
        "--completion-parse=auto",
        "--compile-commands-dir=",
        -- Add these for better diagnostics
        "--log=error",
        "--pretty",
        "--enable-config",
    },
    init_options = {
        clangdFileStatus = true,
        usePlaceholders = true,
        completeUnimported = true,
        semanticHighlighting = true,
        hover = {
            showAKA = true,
            documentation = {
                detailed = true
            }
        },
    },
    capabilities = capabilities,
    on_attach = function(client, bufnr)
        -- Your existing on_attach function
        on_attach(client, bufnr)
        
        -- Enable diagnostics
        vim.diagnostic.config({
            virtual_text = {
                enabled = true,
                prefix = '●',
                spacing = 4,
                format = function(diagnostic)
                    return string.format("%s", diagnostic.message)
                end,
            },
            signs = true,
            underline = true,
            update_in_insert = false,
            severity_sort = true,
            float = {
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
                format = function(diagnostic)
                    return string.format("%s (%s)", diagnostic.message, diagnostic.source)
                end,
            },
        })
        
        -- Set up diagnostic signs
        local signs = {
            Error = " ",
            Warn = " ",
            Hint = " ",
            Info = " "
        }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
        end
    end,
}
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    -- Make the hover window larger
    border = "rounded",
    width = 60,
    -- You can adjust the hover format
    format = function(result)
      if not result then return nil end
      local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result)
      markdown_lines = vim.lsp.util.trim_empty_lines(markdown_lines)
      return markdown_lines
    end,
  }
)
-- Update other language server setups
lspconfig.ts_ls.setup{
  on_attach = on_attach,
}

lspconfig.html.setup{
  on_attach = on_attach,
  capabilities = capabilities,
}

lspconfig.cssls.setup{
  on_attach = on_attach,
}

lspconfig.eslint.setup{
  on_attach = on_attach,
  settings = {
    useESLintClass = true,
    experimental = {
      useFlatConfig = true
    }
  },
}

local mason_registry = require("mason-registry")
HOME_PATH = os.getenv("HOME") .. "/"
MASON_PATH = HOME_PATH .. ".local/share/nvim/mason/packages/"
local codelldb_path = MASON_PATH .. "codelldb/extension/adapter/codelldb"
local liblldb_path = MASON_PATH .. "codelldb/extension/lldb/lib/liblldb.so"

local opts = {
  dap = {
    adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
      },
  server = {
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
    on_attach = function(_, bufnr)
      vim.keymap.set("n", "<Leader>k", rt.hover_actions.hover_actions, { buffer = bufnr })
      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
    end,
  },
  tools = {
    hover_actions = {
      auto_focus = true,
    },
  },
}
--lspconfig.rust_analyzer.setup{
--    on_attach = on_attach,
--    capabilities = capabilities,
--    settings = {
--        ['rust-analyzer'] = {
--            checkOnSave = {
--                command = "check"
--            },
--        },
--    },
--     root_dir = function(fname)
--        return require('lspconfig.util').root_pattern('Cargo.toml', 'rust-project.json')(fname)
--            or require('lspconfig.util').find_git_ancestor(fname)
--    end,
--}
lspconfig.omnisharp.setup{
  cmd = { "omnisharp" },
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    omnisharp = {
      useGlobalMono = "never",
      monoPath = "/usr/bin/mono"
    },
  },
}

local cmp = require('cmp')
cmp.setup({
  -- Enable LSP snippets
  snippet = {
    expand = function(args)
        vim.fn["UltiSnips#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    -- Add tab support
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-S-f>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },
  -- Installed sources:
  sources = {
    { name = 'path' },                              -- file paths
    { name = 'nvim_lsp', keyword_length = 3 },      -- from language server
    { name = 'nvim_lsp_signature_help'},            -- display function signatures with current parameter emphasized
    { name = 'nvim_lua', keyword_length = 2},       -- complete neovim's Lua runtime API such vim.lsp.*
    { name = 'buffer', keyword_length = 2 },        -- source current buffer
    { name = 'ultisnips', keyword_length = 2 },         -- nvim-cmp source for vim-vsnip 
    { name = 'calc'},                               -- source for math calculation
  },
  window = {
    completion = cmp.config.window.bordered({
        winhighlight = "Normal:Normal,FloatBorder:BorderBG,CursorLine:PmenuSel,Search:None",
    }),
    documentation = cmp.config.window.bordered({
        max_height = 20,
        max_width = 80,
        winhighlight = "Normal:Normal,FloatBorder:BorderBG,CursorLine:PmenuSel,Search:None",
    }),
},
  formatting = {
      fields = {'menu', 'abbr', 'kind'},
      format = function(entry, item)
          local menu_icon ={
              nvim_lsp = 'λ',
              vsnip = '⋗',
              buffer = 'Ω',
              path = '🖫',
          }
          item.menu = menu_icon[entry.source.name]
          return item
      end,
  },
})



-- TypeScript
lspconfig.ts_ls.setup{}

-- HTML
lspconfig.html.setup{}

-- CSS
lspconfig.cssls.setup{}

-- JavaScript
lspconfig.eslint.setup{}

-- Configure null-ls for linting and formatting
local null_ls = require("null-ls")
local eslint = require("eslint")

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.prettier
  },
})
eslint.setup({
  bin = 'eslint', -- or 'eslint_d'
  code_actions = {
    enable = true,
    apply_on_save = {
      enable = true,
      types = { "directive", "problem", "suggestion", "layout" },
    },
    disable_rule_comment = {
      enable = true,
      location = "separate_line", -- or 'same_line'
    },
  },
  diagnostics = {
    enable = true,
    report_unused_disable_directives = false,
    run_on = "type", -- or 'save'
    float = {
        border = "rounded",
        wrap_at = 80,  -- or whatever width you prefer
        max_width = 30,
    },
    virtual_text = {
        prefix = '●',
        spacing = 4,
        format = function(diagnostic)
            -- Wrap long messages at word boundaries
            local lines = vim.split(diagnostic.message, "\n")
            return table.concat(lines, " ")
        end,
    },
  },
})
vim.keymap.set('n', '<C-e>', vim.diagnostic.open_float, { noremap = true, silent = true })
-- Configure prettier
local prettier = require("prettier")
prettier.setup({
  bin = 'prettier',
  filetypes = {
    "css",
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "json",
    "scss",
    "less"
  }
})


local function setup_godot_lsp()
  local port = tonumber(os.getenv('GDScript_Port')) or 6005
  local pipe = '/tmp/godot.pipe'
  
  -- Try to connect to Godot LSP
  local ok, cmd = pcall(vim.lsp.rpc.connect, '127.0.0.1', port)
  if not ok then
    -- Don't show error immediately - Godot might not be running
    return false
  end

  -- Configure Godot LSP
  lspconfig.gdscript.setup({
    name = 'Godot',
    cmd = cmd,
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find({ 'project.godot', '.git' }, { upward = true })[1])
    end,
    filetypes = { 'gdscript' },
    capabilities = capabilities,
    on_attach = function(client, bufnr)
      -- Use the same on_attach as other LSP servers
      on_attach(client, bufnr)
      
      -- Start the server for Godot to connect back
      vim.fn.serverstart(pipe)
      vim.notify("Godot LSP attached to buffer " .. bufnr, vim.log.levels.INFO)
    end,
    on_init = function(client)
      vim.notify("Godot LSP initialized on port " .. port, vim.log.levels.INFO)
    end,
    on_exit = function(code, signal)
      if code ~= 0 then
        vim.notify("Godot LSP exited with code: " .. code, vim.log.levels.WARN)
      end
    end,
    settings = {
      -- Add any Godot-specific settings here
    }
  })
  
  return true
end

-- Auto-setup Godot LSP when opening GDScript files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "gdscript",
  callback = function()
    if not setup_godot_lsp() then
      vim.notify("Godot LSP not available. Make sure Godot is running with LSP enabled.", vim.log.levels.WARN)
    end
  end,
})
