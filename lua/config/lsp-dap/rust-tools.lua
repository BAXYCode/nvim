--DAP settings - https://github.com/simrat39/rust-tools.nvim#a-better-debugging-experience
            
            local install_root_dir = vim.fn.stdpath "data" .. "/mason"
            local extension_path = install_root_dir .. "/packages/codelldb/extension/"
            local codelldb_path = extension_path .. "adapter/codelldb"
            local liblldb_path = extension_path .. "lldb/lib/liblldb.so"

local util = require "lspconfig/util"
print('i am sourced')
return

            require("rust-tools").setup({
             single_file_support = false,
                tools = {
                    root_dir = util.root_pattern("Cargo.toml"),
                    autoSetHints = false,
                    executor = require("rust-tools/executors").toggleterm,
                    hover_actions = { border = "rounded" },
                    on_initialized = function()
                        vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "CursorHold", "InsertLeave" }, {
                            pattern = { "*.rs" },
                            callback = function()
                                vim.lsp.codelens.refresh()
                            end,
                        })
                    end,
                    settings = {
                        -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
                        ["rust-analyzer"] = {
                            lens = {
                                enable = true },
                            cargo = { allfeatures = true },
                            checkOnSave = {
                                enable = true,
                                command = "clippy"
                            },
                            completion = {
                                callable = {
                                    snippets = "fill_arguments"
                                }
                            }
                        }
                    }

                },
                dap = {
                    adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
                },
            })
