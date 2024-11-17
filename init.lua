vim.opt.termguicolors = true -- Enable 24-bit RGB colors

vim.loader.enable()
-- Initializing Lazy Setup
require("config.lazy")
require("config.keybindings")
require("config.options")
