local null_ls = require("null-ls")
local nls_utils = require("null-ls.utils")

local M = {}
local b = null_ls.builtins
local sources = {
    --DIAGNOSTICS
    b.diagnostics.luacheck,
    b.diagnostics.markdownlint,
    b.diagnostics.buf,
    b.diagnostics.cppcheck,
    b.diagnostics.eslint_d,
    b.diagnostics.flake8,
    b.diagnostics.ltrs,
    b.diagnostics.markdownlint,
    b.diagnostics.mypy,
    b.diagnostics.solhint,
    b.diagnostics.tidy,

    --FORMATING
    b.formatting.isort,
    b.formatting.black,
    b.formatting.eslint_d,
    b.formatting.gofumpt,
    b.formatting.goimports,
    b.formatting.lua_format,
    b.formatting.prettierd,
--    b.formatting.ruff,
    b.formatting.rustywind,
    b.formatting.stylua,
    b.formatting.tidy,
    b.formatting.uncrustify,

    --COMPLETIONS
    b.completion.luasnip,
}

function M.setup(opts)
    null_ls.setup({
        -- debug = true,
        debounce = 150,
        save_after_format = true,
        sources = sources,
        on_attach = opts.on_attach,
        root_dir = nls_utils.root_pattern(".git"),
    })
end

return M
