local ok, mason = pcall(require,'mason')
if not ok then  return  end

local ok, msconf = pcall(require,"mason-lspconfig")
if not ok then return end

local ok, lszero = pcall(require, "lsp-zero")
if not ok then return end

--setup for rust lsp to function properly
local rust_lsp = lszero.build_options('rust_analyzer', {
    single_file_support = false,
    on_attach = function(client, bufnr)
    end
})

require('rust-tools').setup({ server = rust_lsp })



mason.setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})
require("mason-lspconfig").setup({

})
