local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Opening Oil.nvim
keymap.set("n", "<leader>o", function()
  vim.cmd("Oil")
end,
  { desc = "Open Oil.nvim" }
)

-- Help Buffer Quit Remap
vim.api.nvim_create_autocmd("FileType", {
    pattern = "help",
    callback = function()
        -- Remap <leader>q to :q in help buffers
        vim.api.nvim_buf_set_keymap(0, "n", "<leader>q", ":q<CR>", { noremap = true, silent = true })
    end,
})

-- Handle Bufferline Tab Navigation
-- Create a function to map keys dynamically for bufferline tab navigation (From 1-9)
for i = 1, 9 do
  vim.api.nvim_set_keymap(
    'n',
    '<leader>t' .. i,
    ':lua require("bufferline").go_to(' .. i .. ', true)<CR>',
    { noremap = true, silent = true }
  )
end
