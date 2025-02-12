-- This will run last in the setup process and is a good place to configure
-- things like custom filetypes. This just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

vim.cmd "ab ipdb breakpoint()"

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
vim.api.nvim_set_keymap("n", "<C-j>", "<Plug>(unimpaired-move-down)", { noremap = false, silent = true })
vim.api.nvim_set_keymap("n", "<C-k>", "<Plug>(unimpaired-move-up)", { noremap = false, silent = true })

-- Bubble multiple lines
vim.api.nvim_set_keymap("v", "<C-j>", "<Plug>(unimpaired-move-selection-down)", { noremap = false, silent = true })
vim.api.nvim_set_keymap("v", "<C-k>", "<Plug>(unimpaired-move-selection-up)", { noremap = false, silent = true })

-- Debugging
vim.keymap.set("n", "<Leader>b", function() require("dap").toggle_breakpoint() end)
