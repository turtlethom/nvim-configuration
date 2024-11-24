return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		require("toggleterm").setup({
			size = 50,
			shell = "pwsh.exe",
			open_mapping = [[<leader>tt]], -- Keybinding to toggle terminal
			insert_mappings = false, -- whether or not the open mapping applies in insert mode
			direction = "float",
			shade_terminals = true,
			start_in_insert = true,
		})
	end,
}
