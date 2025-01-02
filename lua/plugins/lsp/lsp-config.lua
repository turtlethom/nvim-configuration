return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      auto_install = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Lua Language Server
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            completion = {
              callSnippet = "Replace",
            },
            workspace = {
              library = {
                -- vim.api.nvim_get_runtime_file("", true), -- Load Neovim runtime files
                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                [vim.fn.stdpath("config") .. "/lua"] = true,
                -- [vim.fn.stdpath("data") .. "/lazy"] = true,
              },
            },
            telemetry = {
              enable = false,
            },
          },
        },
      })

      -- TypeScript Language Server
      lspconfig.ts_ls.setup({
        capabilities = capabilities,
      })

      -- CSS Language Server (cssls)
      lspconfig.cssls.setup({
        capabilities = capabilities,
      })

      -- HTML Language Server
      lspconfig.html.setup({
        capabilities = capabilities,
      })

      -- Emmet Language Server (emmet_ls) - For Emmet Snippets
      require'lspconfig'.emmet_ls.setup{
        capabilities = capabilities,
      }

      -- Python (pylsp) Server
      -- lspconfig.pyright.setup({
      --      capabilities = capabilities,
      -- })

      -- Python (Jedi) Language Server
      lspconfig.jedi_language_server.setup({})
      -- Svelte Language Server
      lspconfig.svelte.setup({
        capabilities = capabilities,
        on_attack = function(client, _)
          vim.api.nvim_create_autocmd("BufWritePost", {
            pattern = { "*.js", "*.ts" },
            callback = function(ctx)
              client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
            end,
          })
        end,
      })

      -- Powershell Language Server
      lspconfig.powershell_es.setup({
        capabilities = capabilities,
        filetypes = { "ps1", "psm1", "psd1" },
        bundle_path = "~/.local/share/nvim/mason/packages/powershell-editor-services",
        settings = { powershell = { codeFormatting = { Preset = "OTBS" } } },
        init_options = {
          enableProfileLoading = false,
        },
      })

      vim.keymap.set("n", "<leader>gh", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { noremap = true, silent = true })
    end,
  },
}
