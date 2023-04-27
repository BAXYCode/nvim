local ok, bufferline = pcall(require, 'bufferline')
if not ok then return end

bufferline.setup {
  options = {
    offsets = {
      { filetype = "NvimTree", text = "", padding = 1 },
      { filetype = "neo-tree", text = "Explorer", padding = 0 },
      { filetype = "Outline", text = "", padding = 1 },
    },
    max_name_length = 14,
    max_prefix_length = 13,
    tab_size = 20,
    separator_style = {" » ", ' » '}
  },
}
local bind = vim.keymap.set

for i = 1, 9 do
  bind("n","<leader>" .. i, function()
    bufferline.go_to_buffer(i, true)
  end)
end
bind("n","<leader>" .. 0, function()
    bufferline.go_to_buffer(-1, true)
end)
