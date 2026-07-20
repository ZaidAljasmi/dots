return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,

    opts = {
      style = "night",
      light_style = "day",
      transparent = false,
      terminal_colors = true,

      styles = {
        comments = { italic = true },
        keywords = { italic = false },
        functions = {},
        variables = {},

        sidebars = "dark",
        floats = "dark",
      },

      day_brightness = 0.3,
      dim_inactive = false,
      lualine_bold = false,

      on_colors = function(colors)
      end,

      on_highlights = function(highlights, colors)
        -- highlights.TelescopeNormal = { bg = "NONE" }
        -- highlights.TelescopeBorder = { bg = "NONE" }
        -- highlights.TelescopePromptNormal = { bg = "NONE" }
        -- highlights.TelescopePromptBorder = { bg = "NONE" }
        -- highlights.TelescopeResultsNormal = { bg = "NONE" }
        -- highlights.TelescopeResultsBorder = { bg = "NONE" }
        -- highlights.TelescopePreviewNormal = { bg = "NONE" }
        -- highlights.TelescopePreviewBorder = { bg = "NONE" }
      end,

      cache = true,

      plugins = {
        all = package.loaded.lazy == nil,
        auto = true,
      },
    },

    config = function(_, opts)
      require("tokyonight").setup(opts)

      -- vim.cmd.colorscheme("tokyonight")
      -- vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#a9b1d6" })
        -- vim.api.nvim_set_hl(0, "CursorLineNr", { bold = false })
    end,
  },
}
