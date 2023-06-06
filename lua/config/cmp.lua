 local M = {}
local cmp = require('cmp')
local lspkind = require('lspkind')
local cmp_select = { behavior = cmp.SelectBehavior.Select }

local mapping = cmp.mapping.preset.insert({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),})

mapping["<Tab>"] = nil
mapping["<S-Tab>"] = nil

vim.diagnostic.config({
    virtual_text = true,
    severity_sort = true,
    float = {
        border = 'rounded',
        source = true
        },
    signs = true,
}) 
cmp.setup({
formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol', -- show only symbol annotations
      maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
      ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
    })
  },
    snippet = {
            expand = function(args)
                require('luasnip').lsp_expand(args.body)
            end
        },
    sources = {
        { name = 'luasnip' },
        { name = 'nvim_lsp' },
        { name = 'path' },
        { name = 'buffer' },
        { name = 'nvim_lsp_signature_help' },
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = mapping,

})
  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })
 local sign = function(opts)
  vim.fn.sign_define(opts.name, {
    texthl = opts.name,
    text = opts.text,
    numhl = ''
  })
end

sign({name = 'DiagnosticSignError', text = ' '})
sign({name = 'DiagnosticSignWarn', text = ' '})
sign({name = 'DiagnosticSignHint', text = ' '})
sign({name = 'DiagnosticSignInfo', text = ' '})

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
 -- cmp.setup.cmdline(':', {
   -- mapping = cmp.mapping.preset.cmdline(),
   -- sources = cmp.config.sources({
     -- { name = 'path' }
   -- }, {
  --    { name = 'cmdline' }
--    })
--})
