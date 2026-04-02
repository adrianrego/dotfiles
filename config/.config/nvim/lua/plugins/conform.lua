-- Customize Conform (formatter) sources
-- Replaces none-ls.nvim for formatting

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
      format_on_save = function(bufnr)
        local ignore = { python = true, yaml = true }
        if ignore[vim.bo[bufnr].filetype] then return end
        return { timeout_ms = 1000, lsp_format = "fallback" }
      end,
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
