local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

-- returns the require for use in `config` parameter of packer"s use
-- expects the name of the config file
function get_config(name)
	return string.format('require("config/%s")', name)
end

-- bootstrap packer if not installed
if fn.empty(fn.glob(install_path)) > 0 then
	fn.system({
		"git",
		"clone",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	execute("packadd packer.nvim")
end

-- initialize and configure packer
local packer = require("packer")

packer.init({
	enable = true, -- enable profiling via :PackerCompile profile=true
	threshold = 0, -- the amount in ms that a plugins load time must be over for it to be included in the profile
})

packer.startup(function(use)
	-- Packer can manage itself
	use("wbthomason/packer.nvim")
	use("tpope/vim-sensible")

	use({ "shaunsingh/nord.nvim", config = get_config("nord") })
	use({
		"nvim-telescope/telescope.nvim",
		requires = { { "nvim-lua/plenary.nvim" } },
		config = get_config("telescope"),
	})

	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })

	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
		config = get_config("lualine"),
	})

	use({
		"kyazdani42/nvim-tree.lua",
		requires = { "kyazdani42/nvim-web-devicons" },
		config = get_config("nvim-tree"),
	})

	use({ "onsails/lspkind-nvim", requires = { "famiu/bufdelete.nvim" } })

	use({
		"jose-elias-alvarez/null-ls.nvim",
		requires = { { "nvim-lua/plenary.nvim" } },
		config = get_config("null-ls"),
	})

	use({ "sindrets/diffview.nvim", requires = "nvim-lua/plenary.nvim" })

	use({
		"hrsh7th/nvim-cmp",
		requires = {
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-cmdline" },
			{ "f3fora/cmp-spell", { "hrsh7th/cmp-calc" }, { "lukas-reineke/cmp-rg" } },
		},
		config = get_config("cmp"),
	})

	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		config = get_config("treesitter"),
	})

	use({ "williamboman/nvim-lsp-installer" })
	use({ "neovim/nvim-lspconfig", after = "nvim-lsp-installer", config = get_config("lsp") })
end)
