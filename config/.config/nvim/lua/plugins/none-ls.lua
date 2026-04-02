-- none-ls has been replaced by conform.nvim — see conform.lua
-- Disable none-ls and its dependencies
---@type LazySpec
return {
  { "nvimtools/none-ls.nvim", enabled = false },
  { "nvimtools/none-ls-extras.nvim", enabled = false },
}
