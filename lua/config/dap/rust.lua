local M = {}

function M.setup()
  local dap_install = require "dap-buddy"
  dap_install.config("codelldb", {})
end

return M
