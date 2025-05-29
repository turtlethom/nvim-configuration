local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Opening Oil.nvim
keymap.set("n", "<leader>o", function()
	vim.cmd("Oil")
end, { desc = "Open Oil.nvim" })

-- Help Buffer Quit Remap
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "help", "fugitive*" },
	callback = function()
		-- Remap <leader>q to :q in help buffers
		vim.api.nvim_buf_set_keymap(0, "n", "<leader>q", ":q<CR>", opts)
	end,
})

-- Handle Bufferline Tab Navigation
-- Create a function to map keys dynamically for bufferline tab navigation (From 1-9)
for i = 1, 9 do
	vim.api.nvim_set_keymap("n", "<leader>t" .. i, ':lua require("bufferline").go_to(' .. i .. ", true)<CR>", opts)
end

-- Keybinds For VimText
vim.api.nvim_set_keymap('n', '<leader>ll', '<plug>(vimtex-compile)', {noremap = false})
vim.api.nvim_set_keymap('n', '<leader>lv', '<plug>(vimtex-view)', {noremap = false})
vim.api.nvim_set_keymap('n', '<leader>lc', '<plug>(vimtex-clean)', {noremap = false})
vim.api.nvim_set_keymap('n', '<leader>lt', '<plug>(vimtex-toc-open)', {noremap = false})
