return {
  {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
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
						["<leader>x"] = actions.close,
					},
				},
			},
		})
		-- Set Keymaps
		vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files, { desc = "Fuzzy find files in cwd" })
		vim.keymap.set("n", "<leader>bf", require("telescope.builtin").current_buffer_fuzzy_find, { desc = "Fuzzy find files in cwd" })
		vim.keymap.set("n", "<leader>fs", require("telescope.builtin").live_grep, { desc = "Find string in cwd" })
    vim.keymap.set("n", "<leader>ht", require("telescope.builtin").help_tags, { desc = "Find all :help files" })
	end,
  },
  {
    'nvim-telescope/telescope-ui-select.nvim',
    config = function()
      require("telescope").setup {
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown {
          }
        }
      }
    }
    require("telescope").load_extension("ui-select")
    end
  }
}
