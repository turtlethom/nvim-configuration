return {
  'projekt0n/github-nvim-theme',
  name = 'github-theme',
  lazy = false,  -- Load this during startup if it's your main colorscheme
  priority = 1000, -- Make sure it's loaded before other plugins
  config = function()
    require('github-theme').setup({
      -- Your custom configuration options for the theme
    })
    vim.cmd('colorscheme github_dark') -- Apply the colorscheme
  end
}

