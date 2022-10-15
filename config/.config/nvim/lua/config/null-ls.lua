local nls = require("null-ls")
local h = require("null-ls.helpers")

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
