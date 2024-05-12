-- Customize None-ls sources

---@type LazySpec
return {
  "nvimtools/none-ls.nvim",
  dependencies = {
      "nvimtools/none-ls-extras.nvim",
	},
	opts = function(_, config)
    -- config variable is the default configuration table for the setup function call
    local null_ls = require "null-ls"

    -- Check supported formatters and linters
    -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/formatting
    -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
    config.sources = {
      -- Set a formatter
			require("none-ls.code_actions.eslint"),
			null_ls.builtins.code_actions.gitsigns,
			null_ls.builtins.completion.spell,
			require("none-ls.diagnostics.eslint"),
			require("none-ls.diagnostics.ruff"),
			require("none-ls.formatting.beautysh"),
			require("none-ls.formatting.ruff"),
			require("none-ls.formatting.eslint"),
			require("none-ls.formatting.jq"),
			null_ls.builtins.formatting.black,
			null_ls.builtins.formatting.prettier,
			null_ls.builtins.formatting.stylua,
			null_ls.builtins.formatting.terraform_fmt,
    }
    return config -- return final config table
  end,
}
