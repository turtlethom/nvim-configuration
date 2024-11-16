return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"folke/todo-comments.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		telescope.setup({
			defaults = {
				path_display = { "smart" },
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						["<leader>q"] = actions.close,
					},
				},
			},
		})

		-- telescope.load_extension("fzf")

		-- Set Keymaps
		vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files, { desc = "Fuzzy find files in cwd" })
		vim.keymap.set("n", "<leader>fr", require("telescope.builtin").oldfiles, { desc = "Fuzzy find recent files" })
		vim.keymap.set("n", "<leader>fs", require("telescope.builtin").live_grep, { desc = "Find string in cwd" })
		vim.keymap.set(
			"n",
			"<leader>fc",
			require("telescope.builtin").grep_string,
			{ desc = "Find string under cursor in cwd" }
		)
	end,
}
