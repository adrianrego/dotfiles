-- Customize Mason plugins

---@type LazySpec
return {
  -- use mason-lspconfig to configure LSP installations
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "bashls",
        "helm_ls",
        "lua_ls",
        "ruff",
        "terraformls",
        "yamlls",
        -- add more arguments for adding more language servers
      },
    },
  },
  -- mason-null-ls removed — formatters now managed via conform.nvim
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      ensure_installed = {
        "python",
        -- add more arguments for adding more debuggers
      },
    },
  },
}
