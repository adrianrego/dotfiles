-- This will run last in the setup process and is a good place to configure
-- things like custom filetypes. This just pure lua so anything that doesn't
-- fit in the normal config locations above can go here


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
