local ok, lsp = pcall(require, 'lsp-zero')
if not ok then return end



lsp.preset("recommended")

lsp.ensure_installed({
  'tsserver',
})

-- Fix Undefined global 'vim'
lsp.configure('lua-language-server', {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
})


local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
  ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
  ['<C-y>'] = cmp.mapping.confirm({ select = true }),
  ["<C-Space>"] = cmp.mapping.complete(),
})

cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

lsp.setup_nvim_cmp({
  mapping = cmp_mappings
})

local lspkind = require('lspkind')
local ELLIPSIS_CHAR = "..."
cmp.setup {
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol', -- show only symbol annotations
      maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
      ellipsis_char = ELLIPSIS_CHAR, -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)

      -- The function below will be called before any actual modifications from lspkind
      -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
      before = function (entry, vim_item)
        return vim_item
      end
    })
  }
}


lsp.on_attach(function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')


client.server_capabilities.semanticTokensProvider = nil
  local bufopt = { noremap = true, silent = true, buffer = bufnr }
  local bind = vim.keymap.set

  bind('n', 'gd', "<cmd>lua require'telescope.builtin'.lsp_definitions()<CR>", bufopt)

  -- bind('n', 'K', vim.lsp.buf.hover, bufopt)
  bind('n', 'K', '<cmd>Lspsaga hover_doc<cr>', bufopt)

  bind('n', '<leader>ca', '<cmd>Lspsaga code_action<cr>', bufopt)
  bind('n', '<leader>lf', function() vim.lsp.buf.format({ async = true }) end, bufopt)
bind('n', '<leader>dd', function() vim.lsp.buf.definition() end, bufopts)
 bind("n", "<leader>vd", function() vim.diagnostic.open_float() end, bufopt)
  bind("n", "<leader>vca", function() vim.lsp.buf.code_action() end, bufopt)
  bind("n", "<leader>vrr", function() vim.lsp.buf.references() end, bufopt)
  bind("n", "<leader>vrn", function() vim.lsp.buf.rename() end, bufopt)
  bind("i", "<C-h>", function() vim.lsp.buf.signature_help() end, bufopt)
  -- Lspsaga Diagnostic
  bind('n', '<leader>dl', '<cmd>Lspsaga diagnostic_jump_next<cr>', bufopt)
  bind('n', '<leader>dh', '<cmd>Lspsaga diagnostic_jump_prev<cr>', bufopt)
end)


local luasnip = require("luasnip")



lsp.setup_nvim_cmp({
  sources = {
    { name = 'path' },
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'luasnip' },
    { name = 'nvim_lsp_signature_help' },
  },
  mapping = cmp_mappings,
  formatting = {
    format = require("lspkind").cmp_format({ mode = "symbol_text",
      maxwidth =50,
      ellipsis_char = "..."
    })
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  }
})

lsp.set_preferences {
  sign_icons = {
    error = 'E',
    warn = 'W',
    hint = 'H',
    info = 'I'
  }
}

lsp.setup()
local rust_lsp = lsp.build_options('rust_analyzer', {
  single_file_support = false,
  on_attach = function(client, bufnr)
  end
})

require('rust-tools').setup({server = rust_lsp})
vim.diagnostic.config({
    virtual_text = true,
    signs = true
})

