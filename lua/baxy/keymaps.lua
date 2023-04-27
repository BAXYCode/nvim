vim.g.mapleader = " "
vim.keymap.set("n","<leader>pv",vim.cmd.Ex)
vim.keymap.set("n","<leader>zu", vim.cmd.update)
--keymaps for harpoon

local mark = require("harpoon.mark")
local ui = require("harpoon.ui")
vim.keymap.set("n","<leader>a", mark.add_file)
vim.keymap.set("n","<C-e>", ui.toggle_quick_menu)
vim.keymap.set("n","<C-h>", function() ui.nav_file(1) end)
vim.keymap.set("n","<C-t>", function() ui.nav_file(2) end)
vim.keymap.set("n","<C-n>", function() ui.nav_file(3) end)
vim.keymap.set("n","<C-s>", function() ui.nav_file(4) end)
----------------------------------------------------------

local bind = vim.keymap.set
-- Lazy git remap
vim.keymap.set("n","gg", vim.cmd.LazyGit)

--Neotree commands
bind("n", "<leader>nt", vim.cmd.Neotree)

--ToggleTerm commands
bind("n", "<leader>tt", vim.cmd.ToggleTerm)

--Dashboard command 
bind("n", "<leader>ds", vim.cmd.Dashboard)
