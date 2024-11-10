-- Loading Personal Keybindings
require("config.keybindings")

-- Lazy Vim Setup
require("config.lazy")

-- Setting Current Theme
vim.cmd("set background=dark")
vim.cmd("colorscheme monokai-nightasty")
-- vim.cmd("colorscheme github_dark_high_contrast")


-- Setting Line Numbers
vim.wo.relativenumber = true

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
