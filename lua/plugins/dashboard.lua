local assets_path = vim.fn.stdpath("config") .. "/assets" -- Grabs Neovim's config directory for Windows/Linux
local ascii_art_path = assets_path .. "/colorized.txt"
local LINES_PER_FILE = 10

local header = {
	-- "                                                                                        ",
	-- "                                                                                        ",
	-- "                                                                                        ",
	-- "████████╗██╗   ██╗███████╗████████╗██╗     ███████╗████████╗██╗  ██╗ ██████╗ ███╗   ███╗",
	-- "╚══██╔══╝██║   ██║██╔══██║╚══██╔══╝██║     ██╔════╝╚══██╔══╝██║  ██║██╔═══██╗████╗ ████║",
	-- "   ██║   ██║   ██║██████╔╝   ██║   ██║     █████╗     ██║   ███████║██║   ██║██╔████╔██║",
	-- "   ██║   ██║   ██║██╔══██╗   ██║   ██║     ██╔══╝     ██║   ██╔══██║██║   ██║██║╚██╔╝██║",
	-- "   ██║   ╚██████╔╝██║  ██║   ██║   ███████╗███████╗   ██║   ██║  ██║╚██████╔╝██║ ╚═╝ ██║",
	-- "   ╚═╝    ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝╚══════╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝",
	-- "                                                                                        ",
	-- "                                                                                        ",
	-- "                                                                                        ",
}
local center = {
	{
		desc = "Find File ",
		key = "f",
		icon = "  > ",
		action = function()
			vim.cmd("Telescope find_files")
		end,
	},
	{
		desc = "New File ",
		key = "n",
		icon = "  > ",
		action = function()
			vim.cmd("ene | startinsert")
		end,
	},
	{
		desc = "Enter Oil ",
		key = "o",
		icon = "󰿄> > ",
		action = function()
			vim.cmd("Oil")
		end,
	},
	{
		desc = "Lazy Plugins",
		key = "l",
		icon = "󰒲  > ",
		action = function()
			vim.cmd("Lazy")
		end,
	},
	{
		desc = "Quit Neovim ",
		key = "q",
		icon = "  > ",
		action = function()
			vim.cmd("qa")
		end,
	},
}

local preview = {
	command = "cat | cat",
	file_path = ascii_art_path,
	file_width = 90,
	file_height = LINES_PER_FILE,
	padding = 5,
}

vim.api.nvim_create_autocmd("FileType", {
	pattern = "dashboard",
	callback = function()
		vim.opt_local.scrolloff = 999 -- Prevent vertical scrolling
		vim.opt_local.sidescrolloff = 999 -- Prevent horizontal scrolling
		vim.opt_local.modifiable = false -- Make the buffer non-modifiable
		vim.opt_local.bufhidden = "wipe" -- Clean up buffer when closed
		vim.opt_local.mouse = "" -- Disable mouse interaction (including scrolling)
	end,
})

-- Function to refresh dashboard buffers
local function refresh_dashboard_buffers()
	-- Get the list of all buffers
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		-- Check if the buffer is related to dashboard preview (e.g., based on the preview file path)
		local buf_name = vim.api.nvim_buf_get_name(buf)
		if buf_name:match("colorized.txt") or buf_name:match("dashboard.lua") then
			-- Close and delete the buffer if it's a dashboard buffer
			if vim.api.nvim_buf_is_valid(buf) then
				vim.api.nvim_buf_delete(buf, { force = true })
			end
		end
	end
	-- Optionally, reopen dashboard preview or other relevant files
	vim.cmd("e " .. ascii_art_path) -- Reload the colorized.txt preview
	vim.cmd("Dashboard") -- Reload the dashboard if necessary
end

-- Autocommand to refresh dashboard buffers on screen resize
vim.api.nvim_create_autocmd("VimResized", {
	pattern = "*", -- This applies to all buffers
	callback = function()
		refresh_dashboard_buffers()
	end,
})

-- Function to handle dashboard preview buffer
vim.api.nvim_create_autocmd("FileType", {
	pattern = "dashboardpreview", -- This applies to the preview buffer specifically
	callback = function()
		vim.opt_local.scrolloff = 0 -- Disable vertical scrolling
		vim.opt_local.sidescrolloff = 0 -- Disable horizontal scrolling
		vim.opt_local.modifiable = false -- Make the buffer non-modifiable (read-only)
	end,
})

return {
	{
		"nvimdev/dashboard-nvim",
    event = "VimEnter",
		opts = {
			theme = "doom",
			config = {
				header = header,
				center = center,
			},
			preview = preview,
		},
	},
}
