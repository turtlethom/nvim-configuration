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
      -- Auto-install essential tools
      local mr = require("mason-registry")
      local tools = {
        "stylua",
        "prettier",
        "shfmt",
      }

      for _, tool in ipairs(tools) do
        local ok, package = pcall(mr.get_package, tool)
        if ok and not package:is_installed() then
          package:install()
        end
      end
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "bashls",
          "ts_ls",
          "cssls",
          "html",
          "emmet_ls",
          "asm_lsp",
          "jedi_language_server",
          "svelte",
          "powershell_es",
        },
        automatic_installation = true,
      })
    end,
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
                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                [vim.fn.stdpath("config") .. "/lua"] = true,
              },
            },
            telemetry = {
              enable = false,
            },
          },
        },
      })

      -- Bash Language Server
      lspconfig.bashls.setup({
        capabilities = capabilities,
      })

      -- TypeScript Language Server (corrected)
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

      -- Emmet Language Server (emmet_ls)
      lspconfig.emmet_ls.setup({
        capabilities = capabilities,
      })

      -- Assembly Language Server (asm_lsp)
      lspconfig.asm_lsp.setup({
        capabilities = capabilities,
      })

      -- Python (Jedi) Language Server
      lspconfig.jedi_language_server.setup({})

      -- Svelte Language Server
      lspconfig.svelte.setup({
        capabilities = capabilities,
        on_attach = function(client, _)
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
