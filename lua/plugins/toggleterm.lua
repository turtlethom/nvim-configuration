return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		require("toggleterm").setup({
			shell = "pwsh.exe",
			open_mapping = [[<leader>tt]], -- Keybinding to toggle terminal
			direction = "float",
			shade_terminals = true,
			start_in_insert = true,
		})
	end,
}
