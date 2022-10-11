function map(mode, shortcut, command)
	vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
end

function nmap(shortcut, command)
	map("n", shortcut, command)
end

function imap(shortcut, command)
	map("i", shortcut, command)
end

function vmap(shortcut, command)
	map("v", shortcut, command)
end

vim.g.mapleader = ","
nmap("<leader>n", ":Neotree toggle<cr>")
nmap("<C-p>", ":Telescope find_files<cr>")
nmap("<C-f>", ":Telescope live_grep<cr>")
nmap("<C-e>", ":TroubleToggle document_diagnostics<cr>")
nmap("<Enter>", ":Telescope buffers<cr>")

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

-- Formating
vim.api.nvim_create_user_command("Format", function()
	vim.lsp.buf.format()
end, {})

-- Code Actions
vim.api.nvim_create_user_command("Actions", function()
	vim.lsp.buf.code_action()
end, {})



-- Abbreviations
vim.cmd("ab ipdb breakpoint()")
