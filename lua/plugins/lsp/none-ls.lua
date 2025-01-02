return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.prettier.with({
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
				}),
				null_ls.builtins.diagnostics.eslint_d,
				null_ls.builtins.completion.spell,
				-- require("none-ls.diagnostics.eslint"), -- requires none-ls-extras.nvim
			},
		})
		vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
	end,
}
