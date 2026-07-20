return {
  {
    "craftzdog/solarized-osaka.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("solarized-osaka").setup({
        -- your configuration comes here
        -- or leave it empty to use the default settings
        transparent = false, -- Enable this to disable setting the background color
        terminal_colors = true, -- Configure the colors used when opening a :terminal in Neovim

        styles = {
          -- Style to be applied to different syntax groups
          comments = { italic = false },
          keywords = { italic = false },
          functions = {},
          variables = {},

          -- Background styles. Can be "dark", "transparent" or "normal"
          sidebars = "dark",
          floats = "dark",
        },

        sidebars = { "qf", "help" },

        day_brightness = 0.3,

        hide_inactive_statusline = false,

        dim_inactive = false,

        lualine_bold = false,

        --- You can override specific color groups to use other groups or a hex color
        ---@param colors ColorScheme
        on_colors = function(colors)
        end,

        --- You can override specific highlights to use other groups or a hex color
        ---@param highlights Highlights
        ---@param colors ColorScheme
        on_highlights = function(highlights, colors)
        end,
      })

      vim.cmd.colorscheme("solarized-osaka")
    end,
  },
}
