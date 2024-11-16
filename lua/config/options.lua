-- Set netrw (built-in file explorer) display style to a vertically aligned, compact list
vim.cmd("let g:netrw_liststyle = 3")

-- Aliases vim.opt for setting options
local opt = vim.opt

-- Display line numbers
opt.relativenumber = true -- Show relative line numbers
opt.number = true -- Show absolute line number for the current line

-- Tabs & indentation settings
opt.tabstop = 2 -- Number of spaces a tab counts for
opt.shiftwidth = 2 -- Number of spaces to use for each step of (auto)indent
opt.expandtab = true -- Convert tabs to spaces
opt.autoindent = true -- Copy the indentation from the current line when starting a new one

-- Text wrapping
opt.wrap = false -- Disable line wrapping

-- Search settings
opt.ignorecase = true -- Ignore case when searching
opt.smartcase = true -- Override 'ignorecase' if search contains uppercase letters

-- Cursor settings
opt.cursorline = true -- Highlight the line where the cursor is located

-- Enable true colors for better color schemes
opt.termguicolors = true -- Enable 24-bit RGB colors
opt.background = "dark" -- Set background theme to dark
opt.signcolumn = "yes" -- Keep the sign column open to prevent text shifting

-- Configure backspace behavior
opt.backspace = "indent,eol,start" -- Allow backspace over indentation, line endings, and insertion point start

-- Clipboard settings
opt.clipboard:append("unnamedplus") -- Use system clipboard as the default register

-- Split window behavior
opt.splitright = true -- Vertical splits open to the right
opt.splitbelow = true -- Horizontal splits open below

-- Disable swapfile creation
opt.swapfile = false -- Prevent creating swap files
