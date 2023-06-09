local M = {}
local cmp =require('config.cmp')


-- local util = require "lspconfig.util"
local servers = {
    html = {},
    jsonls = {
        settings = {
            json = {
                schemas = require("schemastore").json.schemas(),
            },
        },
    },
    pyright = {
        analysis = {
            typeCheckingMode = "on",
        },
    },
    -- pylsp = {}, -- Integration with rope for refactoring - https://github.com/python-rope/pylsp-rope
    lua_ls = {
        settings = {
            Lua = {
                runtime = {
                    -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                    version = "LuaJIT",
                    -- Setup your lua path
                    path = vim.split(package.path, ";"),
                },
                diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = { "vim", "describe", "it", "before_each", "after_each", "packer_plugins" },
                    -- disable = { "lowercase-global", "undefined-global", "unused-local", "unused-vararg", "trailing-space" },
                },
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = {
                        [vim.fn.expand "$VIMRUNTIME/lua"] = true,
                        [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
                    },
                },
                completion = { callSnippet = "luasnip" },
                telemetry = { enable = false },
            },
        },
    },
    tsserver = { disable_formatting = true },
    tailwindcss = {},
    yamlls = {
        schemastore = {
            enable = true,
        },
        settings = {
            yaml = {
                hover = true,
                completion = true,
                validate = true,
                schemas = require("schemastore").json.schemas(),
            },
        },
    },
    dockerls = {},
    kotlin_language_server = {},
}

function M.on_attach(client, bufnr)
    require('config.cmp')
        
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


    client.server_capabilities.semanticTokensProvider = nil
    -- Enable completion triggered by <C-X><C-O>
    -- See `:help omnifunc` and `:help ins-completion` for more information.
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    -- Use LSP as the handler for formatexpr.
    -- See `:help formatexpr` for more information.
    vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")

    -- Configure key mappings
    --require("config.lsp-dap.keymaps").setup(client, bufnr)


    -- tagfunc
    if client.server_capabilities.definitionProvider then
        vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")
    end


    -- nvim-navic
    if client.server_capabilities.documentSymbolProvider then
        local navic = require "nvim-navic"
        navic.attach(client, bufnr)
    end
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
}
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
        "documentation",
        "detail",
        "additionalTextEdits",
    },
}
--local inspect = require 'config.lsp-dap.inspect'
M.capabilities = capabilities
--local inspect = require 'inspect'
--print(inspect(M.capabilities))
local opts = {
    on_attach = M.on_attach,
    capabilities = M.capabilities,
    flags = {
        debounce_text_changes = 150,
    },
}

-- Setup LSP handlers
require("after.plugin.lsp-dap.options").setup()

function M.setup()
    -- null-ls

    require("after.plugin.lsp-dap.null-ls").setup(opts)

    -- Installer
    require("after.plugin.lsp-dap.factory").setup(servers, opts)
    
    --keymaps
    require("after.plugin.lsp-dap.keymaps").setup()
    -- Inlay hints
    -- require("config.lsp.inlay-hints").setup()
end

local diagnostics_active = true

function M.toggle_diagnostics()
    diagnostics_active = not diagnostics_active
    if diagnostics_active then
        vim.diagnostic.show()
    else
        vim.diagnostic.hide()
    end
end

function M.remove_unused_imports()
    vim.diagnostic.setqflist { severity = vim.diagnostic.severity.WARN }
    vim.cmd "packadd cfilter"
    vim.cmd "Cfilter /main/"
    vim.cmd "Cfilter /The import/"
    vim.cmd "cdo normal dd"
    vim.cmd "cclose"
    vim.cmd "wa"
end

return M.setup()
