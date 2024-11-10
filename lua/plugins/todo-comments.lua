return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    -- Custom configuration options
    signs = true,       -- show icons in the sign column
    keywords = {
      FIX = {
        icon = " ",    -- icon used for the FIX keyword
        color = "error", -- highlight as error
      },
      TODO = {
        icon = " ",
        color = "info",
      },
      HACK = {
        icon = " ",
        color = "warning",
      },
    },
  },
}

