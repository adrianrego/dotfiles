-- Mapping data with "desc" stored directly by vim.keymap.set().
--
-- Please use this mappings table to set keyboard mapping
-- lower level configuration and more robust one. (which-key will
-- automatically pick-up stored data by this setting.)
return {
	-- first key is the mode
	n = {
		-- tables with the `name` key will be registered with which-key if it's installed
		-- this is useful for naming menus
	},
	v = {},
	t = {
		-- setting a mapping to false will disable it
		-- ["<esc>"] = false,
	},
}
