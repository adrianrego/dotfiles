-- Devcontainer support: runs LSP servers inside containers, proxies to host Neovim
-- Requires: npm install -g @devcontainers/cli

---@type LazySpec
return {
  {
    "miversen33/netman.nvim",
    lazy = false,
  },
  {
    "jedrzejboczar/devcontainers.nvim",
    dependencies = { "miversen33/netman.nvim" },
    opts = {},
    config = function(_, opts)
      require("devcontainers").setup(opts)

      vim.lsp.config("pyrefly", {
        cmd = require("devcontainers").lsp_cmd { "pyrefly", "lsp" },
        filetypes = { "python" },
        root_dir = function(bufnr, cb)
          local root = vim.fs.root(bufnr, { "pyrefly.toml", "pyproject.toml", ".git" })
          if root then cb(root) end
        end,
      })
      vim.lsp.enable("pyrefly")
    end,
  },
}
