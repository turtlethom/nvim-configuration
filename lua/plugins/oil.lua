return {
	"stevearc/oil.nvim",
	dependencies = { "echasnovski/mini.icons", version = false },
-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
	config = function()
    local oil = require("oil")
    local imageExts = {
      "png",
      "svg",
      "jpg",
      "jpeg",
      "gif",
      "bmp",
      "webp",
    }
    -- Handle selection of images and all other files
    local function custom_select()
      local entry = oil.get_cursor_entry()
      if entry and entry.type == 'file' then
        local ext = entry.name:match("^.+%.([a-zA-Z0-9]+)$")
        if ext and vim.tbl_contains(imageExts, ext:lower()) then
          -- Use "xdg-open" to handle images
          vim.fn.jobstart({ "xdg-open", oil.get_current_dir() .. entry.name }, { detach = true })
          return
        end
      end
      -- Select other files normally with oil.nvim
      oil.select()
    end
    oil.setup({
			skip_confirm_for_simple_edits = true,
			columns = { "icon" },
			keymaps = {
				["g?"] = { "actions.show_help", mode = "n" },
				["<CR>"] = custom_select,
				["<C-h>"] = false,
				["<M-h>"] = "actions.select_split",
				["g."] = { "actions.toggle_hidden", mode = "n" },
				["q"] = "actions.close",
				["<leader>q"] = function()
					oil.close()
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
