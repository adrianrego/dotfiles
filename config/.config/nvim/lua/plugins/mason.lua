-- Customize Mason plugins

---@type LazySpec
return {
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "bashls",
        "dockerls",
        "helm_ls",
        "lua_ls",
        "pyright",
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
