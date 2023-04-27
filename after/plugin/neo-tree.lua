local ok, neotree = pcall(require, 'neo-tree')
if not ok then return end

neotree.setup {
  enable_diagnostics = false,
  default_component_configs = {
    icon = {
      folder_empty = '-'
    },
    git_status = {
      symbols = {
        added = "A",
        deleted = "D",
        modified = "M",
        renamed = "R",
        untracked = "U",
        ignored = "I",
        unstaged = "",
        staged = "",
        conflict = ""
      }
    }
  },
  window = {
    width = 25
  },
file_system = {

    filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored =false,
        hide_hidden = false,
        }
    }
}
