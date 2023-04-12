return {
	-- Configure AstroNvim updates
	updater = {
		remote = "origin", -- remote to use
		channel = "stable", -- "stable" or "nightly"
		version = "latest", -- "latest", tag name, or regex search like "v1.*" to only do updates before v2 (STABLE ONLY)
		branch = "nightly", -- branch name (NIGHTLY ONLY)
		commit = nil, -- commit hash (NIGHTLY ONLY)
		pin_plugins = nil, -- nil, true, false (nil will pin plugins on stable only)
		skip_prompts = false, -- skip prompts about breaking changes
		show_changelog = true, -- show the changelog after performing an update
		auto_quit = false, -- automatically quit the current session after a successful update
		remotes = { -- easily add new remotes to track
		},
	},

	-- Set colorscheme to use
	colorscheme = "astrodark",

	-- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
	diagnostics = {
		virtual_text = true,
		underline = true,
	},

	lsp = {
		-- customize lsp formatting options
		formatting = {
			-- control auto formatting on save
			format_on_save = {
				enabled = true, -- enable or disable format on save globally
				allow_filetypes = { -- enable format on save for specified filetypes only
					-- "go",
				},
				ignore_filetypes = { -- disable format on save for specified filetypes
					-- "python",
				},
			},
			disabled = { -- disable formatting capabilities for the listed language servers
				-- "sumneko_lua",
			},
			timeout_ms = 1000, -- default format timeout
			-- filter = function(client) -- fully override the default formatting function
			--   return true
			-- end
		},
		-- enable servers that you already have installed without mason
		servers = {
			-- "pyright"
		},
	},

	-- Configure require("lazy").setup() options
	lazy = {
		defaults = { lazy = true },
		performance = {
			rtp = {
				-- customize default disabled vim plugins
				disabled_plugins = { "tohtml", "gzip", "matchit", "zipPlugin", "netrwPlugin", "tarPlugin" },
			},
		},
	},

	-- This function is run last and is a good place to configuring
	-- augroups/autocommands and custom filetypes also this just pure lua so
	-- anything that doesn't fit in the normal config locations above can go here
	polish = function()
		vim.cmd("ab ipdb breakpoint()")

		-- Map Ctrl-l and Ctrl-h to indenting or outdenting
		-- while keeping the original selection in visual mode
		vim.api.nvim_set_keymap("v", "<C-l>", ">gv", { noremap = false, silent = true })
		vim.api.nvim_set_keymap("v", "<C-h>", "<gv", { noremap = false, silent = true })

		vim.api.nvim_set_keymap("n", "<C-l>", ">>", { noremap = false, silent = true })
		vim.api.nvim_set_keymap("n", "<C-h>", "<<", { noremap = false, silent = true })

		vim.api.nvim_set_keymap("o", "<C-l>", ">>", { noremap = false, silent = true })
		vim.api.nvim_set_keymap("o", "<C-h>", "<<", { noremap = false, silent = true })

		vim.api.nvim_set_keymap("i", "<C-l>", "<Esc>>>i", { noremap = false, silent = true })
		vim.api.nvim_set_keymap("i", "<C-h>", "<Esc><<i", { noremap = false, silent = true })

		-- Bubble single lines
		vim.api.nvim_set_keymap("n", "<C-j>", "]e", { noremap = false, silent = true })
		vim.api.nvim_set_keymap("n", "<C-k>", "[e", { noremap = false, silent = true })

		-- Bubble multiple lines
		vim.api.nvim_set_keymap("v", "<C-j>", "]egv", { noremap = false, silent = true })
		vim.api.nvim_set_keymap("v", "<C-k>", "[egv", { noremap = false, silent = true })
	end,
}
