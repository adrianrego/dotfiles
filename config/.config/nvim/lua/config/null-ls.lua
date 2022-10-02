local nls = require("null-ls")
nls.setup({
	sources = {
		nls.builtins.code_actions.eslint,
    nls.builtins.code_actions.gitsigns,
		nls.builtins.completion.spell,
		nls.builtins.diagnostics.eslint,
		nls.builtins.diagnostics.flake8,
		nls.builtins.formatting.black,
		nls.builtins.formatting.isort,
		nls.builtins.formatting.prettier,
		nls.builtins.formatting.stylua,
		nls.builtins.formatting.terraform_fmt,
	},
})
