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
      local tools = { "stylua", "prettier", "shfmt" }

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
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Helper to set up LSP servers
      local function setup(server_name, opts)
        opts = vim.tbl_extend("force", {
          capabilities = capabilities,
        }, opts or {})
        vim.lsp.config(server_name, opts)
      end

      -- Lua Language Server
      setup("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim", "love" } },
            completion = { callSnippet = "Replace" },
            workspace = {
              library = {
                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                [vim.fn.stdpath("config") .. "/lua"] = true,
                [vim.fn.expand("~/.local/share/lua-addons/library")] = true,
              },
            },
            telemetry = { enable = false },
          },
        },
      })

      -- Bash Language Server
      setup("bashls")

      -- TypeScript Language Server
      setup("ts_ls")

      -- CSS Language Server
      setup("cssls")

      -- HTML Language Server
      setup("html")

      -- Emmet Language Server
      setup("emmet_ls")

      -- Assembly Language Server
      setup("asm_lsp")

      -- Python (Jedi) Language Server
      setup("jedi_language_server")

      -- Svelte Language Server
      setup("svelte", {
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
      setup("powershell_es", {
        filetypes = { "ps1", "psm1", "psd1" },
        settings = { powershell = { codeFormatting = { Preset = "OTBS" } } },
        init_options = { enableProfileLoading = false },
      })

      -- Keymaps
      vim.keymap.set("n", "<leader>gh", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { noremap = true, silent = true })
    end,
  },
}

