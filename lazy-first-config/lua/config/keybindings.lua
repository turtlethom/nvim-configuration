-- MY PERSONAL REMAPS

-- Global Remappings

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Movement Remappings
vim.api.nvim_set_keymap("i", "jk", "<Esc>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "J", "5j", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "K", "5k", { noremap = true, silent = true })
