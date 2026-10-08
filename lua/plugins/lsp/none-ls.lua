return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
	},
	config = function()
		local null_ls = require("null-ls")
		local capabilities = require("cmp_nvim_lsp").default_capabilities()
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
			capabilities = capabilities,
			sources = {
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.prettier.with(prettier_rules),
				null_ls.builtins.completion.spell,
				null_ls.builtins.formatting.shfmt,
				null_ls.builtins.formatting.gofumpt.with({ extra_args = { "-s" } }), -- Optional: simplify imports
				null_ls.builtins.formatting.goimports_reviser,
			},
			-- Optional: on_attach to set format-on-save or diagnostics
			on_attach = function(client, bufnr)
				if client:supports_method("textDocument/formatting") then
					vim.api.nvim_buf_set_keymap(
						bufnr,
						"n",
						"<leader>gf",
						"<cmd>lua vim.lsp.buf.format({ async = true })<CR>",
						{ noremap = true, silent = true }
					)
				end
			end,
		})

		-- You can still keep a global fallback mapping if you like:
		vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
	end,
}
