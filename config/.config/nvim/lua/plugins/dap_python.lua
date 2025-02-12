return {
  "mfussenegger/nvim-dap-python",
  dependencies = {
    "mfussenegger/nvim-dap",
  },
  config = function(plugin, opts) require("dap-python").setup() end,
}
