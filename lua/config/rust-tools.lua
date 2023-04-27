local ih = require("inlay-hints")
local util = require "lspconfig/util"


require("rust-tools").setup({
    tools = {
        autoSetHints = true,
        runnables = {
            use_telescope = true
        },
        on_initialized = function()
            ih.set_all()
        end,
        inlay_hints = {
            auto = true,
            show_parameter_hints = false,
            other_hints_prefix = "<< ",
        },
    },
    root_dir = util.root_pattern("Cargo.toml"),
    -- See https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
    server = {
        on_attach = function(c, b)
            vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
            ih.on_attach(c, b)
        end,
        settings = {
            -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
            ["rust-analyzer"] = {
                cargo = { allfeatures = true },
                checkOnSave = {
                    command = "clippy"
                },
                completion = {
                    callable = {
                        snippets = "fill_arguments"
                    }
                }
            }
        }
    }
})
