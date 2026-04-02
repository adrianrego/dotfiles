-- Customize Conform (formatter) sources
-- Replaces none-ls.nvim for formatting

---@type LazySpec
return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      css = { "prettier" },
      html = { "prettier" },
      javascript = { "prettier" },
      json = { "jq" },
      lua = { "stylua" },
      markdown = { "prettier" },
      python = { "ruff_format" },
      sh = { "beautysh" },
      terraform = { "terraform_fmt" },
      typescript = { "prettier" },
      yaml = { "prettier" },
    },
  },
}
