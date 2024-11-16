-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Set leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Load plugins using Lazy.nvim
require("lazy").setup({
	spec = {
		require("plugins.init"),
		require("plugins.treesitter"),
		require("plugins.telescope"),
		require("plugins.nvim-tree"),
		require("plugins.lualine"),
		require("plugins.alpha"),
		require("plugins.sonokai-theme"),
		require("plugins.cmp"),
		require("plugins.oil"),
		require("plugins.formatting"),
		require("plugins.autopairs"),
		require("plugins.surround"),
		require("plugins.todo-comments"),
		{ import = "plugins.lsp" },
	},
	install = { colorscheme = { "habamax" } },
	checker = { enabled = true }, -- Auto-check for updates
})
