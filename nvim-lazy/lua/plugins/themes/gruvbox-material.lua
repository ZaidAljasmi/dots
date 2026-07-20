return {
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,

    config = function()
        vim.o.background = "dark"

        -- hard | medium | soft
        vim.g.gruvbox_material_background = "hard"

        -- material | mix | original
        vim.g.gruvbox_material_foreground = "material"

        -- 0 | 1
        vim.g.gruvbox_material_disable_italic_comment = 0

        -- 0 | 1
        vim.g.gruvbox_material_enable_bold = 0

        -- 0 | 1
        vim.g.gruvbox_material_enable_italic = 0

        -- "" | auto | red | orange | yellow | green | aqua | blue | purple
        vim.g.gruvbox_material_cursor = ""

        -- 0 | 1 | 2
        vim.g.gruvbox_material_transparent_background = 0

        -- 0 | 1
        vim.g.gruvbox_material_dim_inactive_windows = 0

        -- grey background | green background | blue background
        -- red background | reverse
        vim.g.gruvbox_material_visual = "grey background"

        -- grey | red | orange | yellow | green | aqua | blue | purple
        vim.g.gruvbox_material_menu_selection_background = "grey"

        -- none | grey | linenr
        vim.g.gruvbox_material_sign_column_background = "none"

        -- none | colored
        vim.g.gruvbox_material_spell_foreground = "none"

        -- low | high
        vim.g.gruvbox_material_ui_contrast = "low"

        -- 0 | 1
        vim.g.gruvbox_material_show_eob = 1

        -- bright | dim | blend
        vim.g.gruvbox_material_float_style = "bright"

        -- 0 | 1
        vim.g.gruvbox_material_diagnostic_text_highlight = 0

        -- 0 | 1
        vim.g.gruvbox_material_diagnostic_line_highlight = 0

        -- grey | colored | highlighted
        vim.g.gruvbox_material_diagnostic_virtual_text = "grey"

        -- grey background | high contrast background
        -- bold | underline | italic
        vim.g.gruvbox_material_current_word = "grey background"

        -- none | dimmed
        vim.g.gruvbox_material_inlay_hints_background = "none"

        -- 0 | 1
        vim.g.gruvbox_material_disable_terminal_colors = 0

        -- default | mix | original
        vim.g.gruvbox_material_statusline_style = "default"

        -- 0 | 1
        vim.g.gruvbox_material_lightline_disable_bold = 0

        -- 0 | 1
        vim.g.gruvbox_material_better_performance = 0

        -- vim.g.gruvbox_material_colors_override = {
        --     fg0 = { "#c8c0a8", "223" },
        -- }

        -- vim.cmd.colorscheme("gruvbox-material")

        -- vim.api.nvim_set_hl(0, "StatusLineTerm", {
        --     fg = "#c8c0a8",
        --     bg = "#282828",
        -- })

        -- vim.api.nvim_set_hl(0, "StatusLine", {
        --     fg = "#c8c0a8",
        --     bg = "#282828",
        -- })

        -- vim.api.nvim_set_hl(0, "LazyNormal", {
        --     fg = "#c8c0a8",
        --     bg = "#1d2021",
        -- })

    end,
}
