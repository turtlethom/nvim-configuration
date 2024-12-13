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
		-- require("plugins.init"),
		-- require("plugins.colorizer"),
		require("plugins.treesitter"),
		require("plugins.plenary"),
		-- require("plugins.telescope"),
		-- require("plugins.nvim-tree"),
		-- require("plugins.dressing"),
		-- require("plugins.lualine"),
		-- require("plugins.alpha"),
		require("plugins.dashboard"),
		require("plugins.sonokai-theme"),
		require("plugins.oil"),
		-- require("plugins.formatting"),
		-- require("plugins.autopairs"),
		-- require("plugins.surround"),
		-- require("plugins.todo-comments"),
		-- require("plugins.toggleterm"),
		-- require("plugins.bufferline"),
		{ import = "plugins.lsp" },
	},
	install = { colorscheme = { "habamax" } },
	checker = { enabled = true }, -- Auto-check for updates
})
