-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "bash",
      "css",
      "dockerfile",
      "hcl",
      "html",
      "lua",
      "python",
      "vim",
      -- add more arguments for adding more treesitter parsers
    },
  },
}
