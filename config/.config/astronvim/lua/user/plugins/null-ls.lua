return {
	"jose-elias-alvarez/null-ls.nvim",
	opts = function(_, config)
		-- config variable is the default configuration table for the setup function call
		local nls = require("null-ls")
		local h = require("null-ls.helpers")

		local gherkin = h.make_builtin({
			name = "reformat-gherkin",
			meta = {
				url = "https://github.com/ducminh-phan/reformat-gherkin",
				description = "Reformat-gherkin automatically formats Gherkin files.",
			},
			method = nls.methods.FORMATTING,
			filetypes = { "cucumber" },
			generator_opts = {
				command = "reformat-gherkin",
				args = {
					"-",
				},
				to_stdin = true,
			},
			factory = h.formatter_factory,
		})

		nls.register(gherkin)

		config.sources = {
			nls.builtins.code_actions.eslint,
			nls.builtins.code_actions.gitsigns,
			nls.builtins.completion.spell,
			nls.builtins.diagnostics.eslint,
			nls.builtins.diagnostics.ruff,
			nls.builtins.formatting.beautysh,
			nls.builtins.formatting.black,
			nls.builtins.formatting.ruff,
			nls.builtins.formatting.fixjson,
			nls.builtins.formatting.eslint,
			nls.builtins.formatting.prettier,
			nls.builtins.formatting.stylua,
			nls.builtins.formatting.terraform_fmt,
		}
		return config -- return final config table
	end,
}
