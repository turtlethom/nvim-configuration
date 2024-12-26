return {
	"nvim-treesitter/nvim-treesitter",
	version = "v0.9.1",
	build = ":TSUpdate",
	opts = {
		ensure_installed = {
			"lua",
			"javascript",
			"typescript",
			"css",
			"gitignore",
			"json",
			"vim",
			"vimdoc",
		},
		highlight = {
			enable = true,
			disable = { "help" },
		},
		indent = { enable = true },
		query_linter = {
			enable = true,
			use_virtual_text = true,
			lint_events = { "BufWrite", "CursorHold" },
		},
	},
}
