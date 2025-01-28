-- Customize Neotree

---@type LazySpec
return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = function(_, opts)
    opts = {
      filesystem = {
        filtered_items = {
          visible = true,
          show_hidden_count = true,
          hide_dotfiles = false,
          hide_gitignored = true,
          hide_by_name = {},
          never_show = {
            ".pytest_cache",
            ".ipython",
            ".gitkeep",
            ".git",
          },
        },
      },
    }

    return opts
  end,
}
