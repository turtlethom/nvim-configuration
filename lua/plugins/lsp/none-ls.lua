return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
	},
	config = function()
		local null_ls = require("null-ls")
		local prettier_rules = {
			extra_args = {
				"--print-width",
				"1000", -- Large value to avoid wrapping
				"--tab-width",
				"2", -- Default indentation width
				"--use-tabs",
				"false", -- Ensure spaces are used
				"--single-quote",
				"false",
				"--html-whitespace-sensitivity",
				"ignore",
				"--prose-wrap",
				"never",
			},
		}
		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.prettier.with(prettier_rules),
				-- require("none-ls.diagnostics.eslint"), -- requires none-ls-extras.nvim
				null_ls.builtins.completion.spell,
			},
		})
		vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
	end,
}
