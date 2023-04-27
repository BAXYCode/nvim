local ok, conf = pcall(require, "nvim-treesitter.configs")
if not ok then return end


require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the four listed parsers should always be installed)
 ensure_installed = {"typescript","c","cpp","python","svelte","rust","javascript"},
  disable = {},
  sync_install = false,
  ignore_install = false,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {enable = true},
  
}
