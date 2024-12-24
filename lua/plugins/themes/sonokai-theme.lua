return {
  {
        'sainnhe/sonokai',
        lazy = false,
        priority = 1000,
        config = function()
          -- Optionally configure and load the colorscheme
          -- directly inside the plugin declaration.
          vim.g.sonokai_enable_italic = true
          vim.g.sonokai_transparent_background = 1
          vim.g.sonokai_style = 'espresso'
          vim.cmd.colorscheme('sonokai')
        end
  }
}
