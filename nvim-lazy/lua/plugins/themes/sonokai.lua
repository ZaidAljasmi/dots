return {
  {
    "sainnhe/sonokai",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.sonokai_style = "atlantis" -- default / atlantis / andromeda / shusia / maia / espresso

      vim.g.sonokai_enable_italic = 0
      vim.g.sonokai_disable_italic_comment = 0
      vim.g.sonokai_better_performance = 1

    end,
  },
}
