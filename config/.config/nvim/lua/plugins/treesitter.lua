-- Customize Treesitter
-- v6: treesitter config moved to astrocore opts

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    treesitter = {
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
      highlight = true,
    },
  },
}
