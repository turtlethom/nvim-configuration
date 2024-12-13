vim.opt.termguicolors = true -- Enable 24-bit RGB colors

-- Set leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.loader.enable()
-- Initializing Lazy Setup
require("config.lazy")
require("config.keybindings")
require("config.options")
