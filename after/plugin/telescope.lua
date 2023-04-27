local ok, builtin = pcall(require, "telescope.builtin")
if not ok then return end

local telescope = require('telescope')
telescope.load_extension("persisted")
telescope.setup {
  extensions = {
    ["ui-select"] = {
      require'telescope.themes'.get_dropdown()
    },
  }
}



vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
telescope.load_extension("ui-select")
