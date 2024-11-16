return {
	"goolord/alpha-nvim",
	require = { "echasnovski/mini.icons" },
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")
		local stats = require("lazy").stats()
		local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
		local colors = {
			red = "#ff0000",
			green = "#00ff00",
			blue = "#0000ff",
			yellow = "#ffff00",
			cyan = "#00ffff",
			magenta = "#ff00ff",
			orange = "#ffa500",
			pink = "#ffc0cb",
			white = "#ffffff",
			neonpink = "#FF0080",
		}

		-- Function to define highlight groups
		local function set_highlights()
			vim.api.nvim_set_hl(0, "AlphaHeader", { fg = colors.neonpink, bold = true })
			vim.api.nvim_set_hl(0, "AlphaButtons", { fg = colors.neonpink, bold = true })
			vim.api.nvim_set_hl(0, "AlphaFooter", { fg = colors.neonpink, italic = true })
		end

		-- Create custom buttons
		local function buttonhl(shortcut, text, command, hl)
			local button = dashboard.button(shortcut, text, command)
			button.opts.hl = hl
			button.opts.position = "center"
			button.opts.hl_shortcut = hl
			return button
		end

		-- Create autocmd to set highlights when Alpha is ready
		vim.api.nvim_create_autocmd("User", {
			pattern = "AlphaReady",
			callback = function()
				set_highlights()
			end,
		})

		-- Define the logo lines
		dashboard.section.header.val = {
			"                                                                                        ",
			"████████╗██╗   ██╗███████╗████████╗██╗     ███████╗████████╗██╗  ██╗ ██████╗ ███╗   ███╗",
			"╚══██╔══╝██║   ██║██╔══██║╚══██╔══╝██║     ██╔════╝╚══██╔══╝██║  ██║██╔═══██╗████╗ ████║",
			"   ██║   ██║   ██║██████╔╝   ██║   ██║     █████╗     ██║   ███████║██║   ██║██╔████╔██║",
			"   ██║   ██║   ██║██╔══██╗   ██║   ██║     ██╔══╝     ██║   ██╔══██║██║   ██║██║╚██╔╝██║",
			"   ██║   ╚██████╔╝██║  ██║   ██║   ███████╗███████╗   ██║   ██║  ██║╚██████╔╝██║ ╚═╝ ██║",
			"   ╚═╝    ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝╚══════╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝",
			"                                                                                        ",
		}
		dashboard.section.header.opts.hl = "AlphaHeader"

		-- Set menu
		dashboard.section.buttons.val = {
			buttonhl("f", "  > Find File", ":Telescope find_files<CR>", "AlphaButtons"),
			buttonhl("n", "  > New File", ":ene | startinsert<CR>", "AlphaButtons"),
			buttonhl("o", "󰿄  > Enter Oil", "<CMD>Oil<CR>", "AlphaButtons"),
			-- buttonhl("s", "  > Restore Session", ":lua require('persistence').load()<CR>", "AlphaButtons"),
			buttonhl("l", "󰒲  > Lazy Plugins", ":Lazy<CR>", "AlphaButtons"),
			buttonhl("q", "  > Quit Neovim", ":qa<CR>", "AlphaButtons"),
		}

		-- Set footer
		dashboard.section.footer.val = {
			"",
			"-- ⚡ LazyVim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins   in " .. ms .. "ms --",
			"",
		}
		dashboard.section.footer.opts.hl = "AlphaFooter"

		-- Send config to alpha
		alpha.setup(dashboard.opts)

		-- Disable folding on alpha buffer
		vim.cmd([[ autocmd FileType alpha setlocal nofoldenable ]])
	end,
}
