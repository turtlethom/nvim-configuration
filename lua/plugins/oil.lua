return {
	"stevearc/oil.nvim",
	dependencies = { "echasnovski/mini.icons", version = false },
	config = function()
		require("oil").setup({
			skip_confirm_for_simple_edits = true,
			columns = { "icon" },
			keymaps = {
				["<C-h>"] = false,
				["<M-h>"] = "actions.select_split",
        ["g."] = { "actions.toggle_hidden", mode = "n" },
				["q"] = "actions.close",
				["<leader>q"] = function()
					require("oil").close()
          vim.cmd("q!")
					-- vim.cmd("Dashboard")
				end,
			},
			view_options = {
				show_hidden = true,
			},
		})

		-- Open parent directory in current window
		vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

		-- Open parent directory in floating window
		vim.keymap.set("n", "<space>-", require("oil").toggle_float)
	end,
}
