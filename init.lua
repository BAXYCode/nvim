local home_dir = os.getenv("HOME")
package.path = home_dir .. "/.config/nvim/after/plugin/?.lua;" .. package.path
require('baxy')
vim.opt.termguicolors = true
vim.cmd([[colorscheme rose-pine]])
