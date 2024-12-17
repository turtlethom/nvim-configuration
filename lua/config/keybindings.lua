local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Disabling Leader Key In Insert Mode
keymap.set("i", "<space>", "<space>", opts)

-- Remove Highlighting
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- Movement Remappings
keymap.set("i", "jk", "<Esc>", opts)
keymap.set("n", "J", "5j", opts)
keymap.set("n", "K", "5k", opts)

-- Commenting Remap
keymap.set("n", "<C-/>/", "gcc", { desc = "Comment out line(s) of code" })

-- Saving & Quitting Files
keymap.set("n", "<Leader>w", ":update<Return>", opts)
keymap.set("n", "<Leader>q", function()
	vim.cmd("bd!")
	-- require("alpha").start()
	vim.cmd("Dashboard")
	-- require("snacks").dashboard.open()
end, opts)
keymap.set("n", "<Leader>Q", ":q!<Return>", opts)

-- Increment/Decrement Numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- Window Management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<CMD>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>to", "<CMD>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<CMD>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<CMD>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<CMD>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<CMD>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- Opening Oil.nvim
keymap.set("n", "<leader>o", function()
  vim.cmd("bd")
  vim.cmd("Oil")
end,
  { desc = "Open Oil" }) -- open Oil buffer from file edits

-- Fold Open/Close Remaps
keymap.set("n", "<leader>u", "zo", { desc = "Open/unfold fold" })
keymap.set("n", "<leader>h", "zc", { desc = "Close/hide fold" })
