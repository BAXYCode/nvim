local M = {}

function M.setup(servers, options)
   local neodev =  require("neodev").setup({
  -- add any options here, or leave empty to use the default settings
})
    local lspconfig = require "lspconfig"
    local icons = require "config.icons"
    local util = require "lspconfig/util"

-- following code is to fix neovim never closing when exiting. 
--local ok, wf = pcall(require, "vim.lsp._watchfiles")
 -- if ok then
  --   -- disable lsp watcher. Too slow on linux
   --  wf._watchfunc = function()
    --   return function() end
    -- end
 -- end
    require("mason").setup {
        ui = {
            icons = {
                package_installed = icons.server_installed,
                package_pending = icons.server_pending,
                package_uninstalled = icons.server_uninstalled,
            },
        },
    }


    require("mason-lspconfig").setup {
        ensure_installed = vim.tbl_keys(servers),
        automatic_installation = false,
    }

    -- Package installation folder
    local install_root_dir = vim.fn.stdpath "data" .. "/mason"

    require("mason-lspconfig").setup_handlers ({
        function(server_name)
            local opts = vim.tbl_deep_extend("force", options, servers[server_name] or {})
            lspconfig[server_name].setup { opts }
        end,
        ["lua_ls"] = function()
            local opts = vim.tbl_deep_extend("force", options, servers["lua_ls"] or {})
            lspconfig.lua_ls.setup({opts})
            
        end,
        ["rust_analyzer"] = function()
            local opts = vim.tbl_deep_extend("force", options, servers["rust_analyzer"] or {})
            require('config.lsp-dap.rust-tools')
            -- DAP settings - https://github.com/simrat39/rust-tools.nvim#a-better-debugging-experience
           -- local extension_path = install_root_dir .. "/packages/codelldb/extension/"
            --local codelldb_path = extension_path .. "adapter/codelldb"
           -- local liblldb_path = extension_path .. "lldb/lib/liblldb.so"
            --require("rust-tools").setup({
  --              single_file_support = false,
                --tools = {
--                    root_dir = util.root_pattern("Cargo.toml"),
 --                   autoSetHints = false,
  --                  executor = require("rust-tools/executors").toggleterm,
 --                   hover_actions = { border = "rounded" },
 --                   on_initialized = function()
  --                      vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "CursorHold", "InsertLeave" }, {
   --                         pattern = { "*.rs" },
    --                        callback = function()
     --                           vim.lsp.codelens.refresh()
      --                      end,
       --                 })
        --            end,
  --                  settings = {
                        -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
   --                     ["rust-analyzer"] = {
--                            lens = {
 --                               enable = true },
--                            cargo = { allfeatures = true },
--                            checkOnSave = {
--                                enable = true,
--                                command = "clippy"
--                            },
   --                         completion = {
    --                            callable = {
     --                               snippets = "fill_arguments"
      --                          }
       --                     }
   --                     }
    --                }

             --   },
               -- server = opts,
            --    dap = {
             --       adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
              --  },
           -- })
        end,
        ["tsserver"] = function()
            local opts = vim.tbl_deep_extend("force", options, servers["tsserver"] or {})
            require("typescript").setup {
                disable_commands = false,
                debug = false,
                server = opts,
            }
        end,
    })


end

return M
