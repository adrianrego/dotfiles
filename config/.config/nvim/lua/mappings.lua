function map(mode, shortcut, command)
  vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
end

function nmap(shortcut, command)
  map('n', shortcut, command)
end

function imap(shortcut, command)
  map('i', shortcut, command)
end

vim.g.mapleader = ","
nmap('<leader>n', ':NvimTreeToggle<cr>')
nmap('<C-p>', ':Telescope find_files<cr>')
nmap('<C-f>', ':Telescope live_grep<cr>')
nmap('<Enter>', ':Telescope buffers<cr>')

vim.api.nvim_create_user_command(
	'Format',
	function ()
		vim.lsp.buf.formatting()
	end,
	{}
)
