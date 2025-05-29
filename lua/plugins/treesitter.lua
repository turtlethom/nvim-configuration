return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local configs = require("nvim-treesitter.configs")
    configs.setup({
      -- ensure_installed = { "lua", "javascript" },
      auto_install = true,
      highlight = {
        enable = true,
        disable = { "latex" }
      },
      indent = { 
        enable = true,
        disable = { "latex" }
      },
    })
  end,
}
