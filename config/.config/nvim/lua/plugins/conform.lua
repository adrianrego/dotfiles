-- Customize Conform (formatter) sources

---@type LazySpec
return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = {
      formatters_by_ft = {
        json = { "jq" },
        lua = { "stylua" },
        markdown = { "dprint" },
        python = { "ruff_organize_imports", "ruff_format" },
        sh = { "shfmt" },
        terraform = { "terraform_fmt" },
        yaml = { "dprint" },
      },
      default_format_opts = {
        lsp_format = "fallback",
      },
      format_on_save = {
        timeout_ms = 1000,
        lsp_format = "fallback",
      },
    },
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
  -- Override AstroLSP's ,lf mapping to use conform
  {
    "AstroNvim/astrolsp",
    opts = {
      mappings = {
        n = {
          ["<Leader>lf"] = {
            function() require("conform").format({ lsp_format = "fallback" }) end,
            desc = "Format buffer",
          },
        },
        v = {
          ["<Leader>lf"] = {
            function() require("conform").format({ lsp_format = "fallback" }) end,
            desc = "Format buffer",
          },
        },
      },
    },
  },
}
