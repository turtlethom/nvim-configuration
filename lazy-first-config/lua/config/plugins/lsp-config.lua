return {
	-- Loading Mason Itself
	{
		"williamboman/mason.nvim",
		lazy = false, -- Load immediately if you prefer, or set to true to load lazily
		config = function()
		    require("mason").setup({
			ui = {
        			icons = {
				    package_installed = "✓",
				    package_pending = "➜",
				    package_uninstalled = "✗"
				}
			}
		    })
		end,
    	},

	-- Loading Mason-LSP Config; ensures LSP Servers are managed through Mason
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
		config = function()
		    require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",		-- Lua
				"html",			-- HTML
				"svelte",		-- Svelte
				"emmet_ls",		-- Emmet
				"prismals",		-- Prisma
				"pyright",		-- Python
				"eslint",		-- JavaScript
				"ast_grep",		-- Java
				"clangd",		-- C/C++
				"ts_ls",		-- TypeScript
			},
			-- Auto-Install configured servers (with lspconfig)
			automatic_installation = true, -- not the same as ensure_installed
		    })
		end,
	},
	-- Nvim-LSP Config Itself; configures all LSP functionality
	{
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")

            -- Setup for lua_ls (or any other server)
            lspconfig.lua_ls.setup({
                settings = {
                    Lua = {
                        runtime = {
                            -- Specify Lua version (adjust if needed)
                            version = 'LuaJIT',
                        },
                        diagnostics = {
                            -- Get the language server to recognize 'vim' as a global
                            globals = { 'vim' },
                        },
                        workspace = {
                            -- Make the server aware of Neovim runtime files
                            library = vim.api.nvim_get_runtime_file("", true),
                        },
                        telemetry = {
                            enable = false,
                        },
                    },
                },
            })

            -- Add additional language servers if needed
            -- Example:
            -- lspconfig.pyright.setup({})
        end,
    },
}
