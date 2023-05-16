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

lsp.set_server_config({
    on_init = function(client)
        client.server_capabilities.semanticTokensProvider = nil
    end,
})
local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
})

cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil



local lspkind = require('lspkind')
local ELLIPSIS_CHAR = "..."

vim.diagnostic.config({
    virtual_text = true,
    severity_sort = true,
    float = {
        border = 'rounded',
        source = 'always'
        },
    signs = true,
})

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
    bind('n', '<leader>dd', function() vim.lsp.buf.definition() end, bufopt)
    bind("n", "<leader>vd", function() vim.diagnostic.open_float() end, bufopt)
    bind("n", "<leader>vca", function() vim.lsp.buf.code_action() end, bufopt)
    bind("n", "<leader>vrr", function() vim.lsp.buf.references() end, bufopt)
    bind("n", "<leader>vrn", function() vim.lsp.buf.rename() end, bufopt)
    bind("i", "<C-h>", function() vim.lsp.buf.signature_help() end, bufopt)
    -- Lspsaga Diagnostic
    bind('n', '<leader>dl', '<cmd>Lspsaga diagnostic_jump_next<cr>', bufopt)
    bind('n', '<leader>dh', '<cmd>Lspsaga diagnostic_jump_prev<cr>', bufopt)
end)


local luasnip = require("luasnip").setup()



lsp.setup_nvim_cmp({
    snippet = {
            expand = function(args)
                require('luasnip').lsp_expand(args.body)
            end
        },
    sources = {
        { name = 'path' },
        {name = 'cmp_luasnip'},
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'luasnip' },
        { name = 'nvim_lsp_signature_help' },
    },
    mapping = cmp_mappings,
    formatting = {
        format = require("lspkind").cmp_format({
            mode = "symbol",
            maxwidth = 30,
            ellipsis_char = "...",
            before = function(entry, vim_item)
                return vim_item
            end

        })
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    }
})

lsp.set_preferences {
    sign_icons = {
        error = " ",
        warn = " ",
        hint = " ",
        info = " "
    }
}

lsp.setup()
require "config.lsp-dap"
