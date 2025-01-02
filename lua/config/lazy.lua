-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Load plugins using Lazy.nvim
require("lazy").setup({
	spec = {
		require("plugins.colorizer"),
		require("plugins.tmux-navigator"),
		require("plugins.treesitter"),
		require("plugins.plenary"),
    require("plugins.noice"),
		require("plugins.telescope"),
		require("plugins.dressing"),
		require("plugins.lualine"),
		require("plugins.themes.sonokai-theme"),
		require("plugins.oil"),
    require("plugins.git-integration"),
		require("plugins.todo-comments"),
		require("plugins.bufferline"),
		{ import = "plugins.lsp" },
	},
	-- install = { colorscheme = { "habamax" } },
	checker = { enabled = true }, -- Auto-check for updates
})
