return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = function()
    -- update changed parsers two at a time instead of up to 100 at once
    require("nvim-treesitter").update(nil, { max_jobs = 2 }):wait(300000)
  end,
  config = function()
    local ts = require("nvim-treesitter")
    local available -- filled on first use
    local pending = {}

    local function start(buf)
      if vim.api.nvim_buf_is_valid(buf) and pcall(vim.treesitter.start, buf) then
        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    end

    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        if args.match == "tex" then return end -- LaTeX stays with vimtex
        local lang = vim.treesitter.language.get_lang(args.match) or args.match
        if vim.tbl_contains(ts.get_installed("parsers"), lang) then
          return start(args.buf)
        end
        available = available or ts.get_available()
        if not vim.tbl_contains(available, lang) or pending[lang] then return end
        -- auto-install missing parsers, one build at a time
        pending[lang] = true
        ts.install({ lang }, { max_jobs = 1 }):await(function()
          pending[lang] = nil
          vim.schedule(function() start(args.buf) end)
        end)
      end,
    })
  end,
}
