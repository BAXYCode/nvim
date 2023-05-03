local M = {}

local lzero = pcall(require, 'lsp-zero')
local mason_path = vim.fn.glob(vim.fn.stdpath "data" .. "/mason/")
local codelldb_adapter = {
  type = "server",
  port = "${port}",
  executable = {
    command = mason_path .. "bin/codelldb",
    args = { "--port", "${port}" },
  },
}


function M.setup()
 

local ih = require("inlay-hints")
local util = require "lspconfig/util"


local rt = require("rust-tools").setup({
    tools = {

        executor = require("rust-tools/executors").toggleterm, -- can be quickfix or termopen
      reload_workspace_from_cargo_toml = true,
      runnables = {
        use_telescope = true,
      },
        autoSetHints = true,
        on_initialized = function()
            ih.set_all()
        end,
        inlay_hints = {
            auto = true,
            show_parameter_hints = false,
            other_hints_prefix = "<< ",
        },
    
        hover_actions = {
        border = "rounded",
      },

      on_initialized = function()
        vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "CursorHold", "InsertLeave" }, {
          pattern = { "*.rs" },
          callback = function()
            local _, _ = pcall(vim.lsp.codelens.refresh)
          end,
        })
      end,

    },
    root_dir = util.root_pattern("Cargo.toml"),
    -- See https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer

    dap = {
        adapter = codelldb_adapter,
    },
    server = {
        on_attach = function(c, b)
            local rt = require("rust-tools")
            vim.keymap.set("n", "K", rt.hover_actions.hover_actions, { buffer = bufnr })
            ih.on_attach(c, b)
        end,
        settings = {
            -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
            ["rust-analyzer"] = {
                lens = { 
                        enable = true},
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
    }
})

lzero.configure('rust-analyzer', rt.server)
end

lvim.builtin.dap.on_config_done = function(dap)
  dap.adapters.codelldb = codelldb_adapter
  dap.configurations.rust = {
    {
      name = "Launch file",
      type = "codelldb",
      request = "launch",
      program = function()
        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
    },
  }end
return M 
