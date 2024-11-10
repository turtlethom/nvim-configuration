return {
  "nvimdev/dashboard-nvim",
  lazy = false,  -- Ensures dashboard-nvim handles stdin properly
  opts = function()
    -- Define the ASCII logo
    local logo = [[
      ████████╗██╗   ██╗██████╗ ████████╗██╗     ███████╗████████╗██╗  ██╗ ██████╗ ███╗   ███╗
      ╚══██╔══╝██║   ██║██╔══██╗╚══██╔══╝██║     ██╔════╝╚══██╔══╝██║  ██║██╔═══██╗████╗ ████║
         ██║   ██║   ██║██████╔╝   ██║   ██║     █████╗     ██║   ███████║██║   ██║██╔████╔██║
         ██║   ██║   ██║██╔══██╗   ██║   ██║     ██╔══╝     ██║   ██╔══██║██║   ██║██║╚██╔╝██║
         ██║   ╚██████╔╝██║  ██║   ██║   ███████╗███████╗   ██║   ██║  ██║╚██████╔╝██║ ╚═╝ ██║
         ╚═╝    ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝╚══════╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝
    ]]

    -- Configure the options for the dashboard
    local opts = {
      theme = "doom",  -- Can be "hyper" or another theme if preferred
      hide = {
        statusline = false,  -- Hide the statusline
      },
      config = {
        header = vim.split("\n\n\n\n" .. logo, "\n"),  -- Adds ASCII logo as the header
        center = {
          { action = "Telescope find_files",          desc = " Find File",       icon = " ", key = "f" },
          { action = "ene | startinsert",             desc = " New File",        icon = " ", key = "n" },
          { action = "Telescope oldfiles",            desc = " Recent Files",    icon = " ", key = "r" },
          { action = "Telescope live_grep",           desc = " Find Text",       icon = " ", key = "g" },
          { action = "Telescope file_browser",        desc = " File Browser",    icon = " ", key = "b" },
          { action = "lua require('persistence').load()", desc = " Restore Session", icon = " ", key = "s" },
          { action = "Lazy",                          desc = " Lazy Plugins",    icon = "󰒲 ", key = "l" },
          { action = function() vim.cmd("qa") end,    desc = " Quit Neovim",     icon = " ", key = "q" },
        },
        footer = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
        end,
      },
    }

    -- Ensure action descriptions are aligned
    for _, button in ipairs(opts.config.center) do
      button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
      button.key_format = "  %s"
    end

    -- Autocmd to reopen dashboard after closing Lazy window
    if vim.o.filetype == "lazy" then
      vim.api.nvim_create_autocmd("WinClosed", {
        pattern = tostring(vim.api.nvim_get_current_win()),
        once = true,
        callback = function()
          vim.schedule(function()
            vim.api.nvim_exec_autocmds("UIEnter", { group = "dashboard" })
          end)
        end,
      })
    end

    return opts
  end,
  dependencies = { { "nvim-tree/nvim-web-devicons" } },
}

