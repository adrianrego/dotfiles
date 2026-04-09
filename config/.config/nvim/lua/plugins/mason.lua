-- Customize Mason plugins

---@type LazySpec
return {
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      automatic_installation = false,
      ensure_installed = {
        "bashls",
        "dockerls",
        "helm_ls",
        "lua_ls",
        "ruff",
        "terraformls",
        "yamlls",
      },
    },
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      ensure_installed = {
        "python",
      },
    },
  },
}
