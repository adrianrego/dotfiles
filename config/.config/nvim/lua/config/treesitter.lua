require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"bash",
		"dockerfile",
		"go",
		"hcl",
		"html",
		"java",
		"javascript",
		"json",
		"latex",
		"ledger",
		"lua",
		"python",
		"toml",
		"yaml",
		"markdown",
	}, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
})
