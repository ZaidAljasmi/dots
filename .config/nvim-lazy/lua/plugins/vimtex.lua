return {
  {
    "lervag/vimtex",
    lazy = false,

    init = function()
      -- PDF viewer
      vim.g.vimtex_view_method = "zathura"

      -- Compiler
      vim.g.vimtex_compiler_method = "latexmk"

      vim.g.vimtex_compiler_latexmk = {
        build_dir = "build",
        out_dir = "build",
        aux_dir = "build",
        options = {
          "-interaction=nonstopmode",
          "-file-line-error",
          "-synctex=1",
        },
      }

      -- Ignore noisy warnings
      vim.g.vimtex_quickfix_ignore_filters = {
        "Underfull",
        "Overfull",
        "Package hyperref Warning",
      }

      vim.g.tex_flavor = "latex"
    end,
  },
}
