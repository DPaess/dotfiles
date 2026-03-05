local M = {
  "Mofiqul/dracula.nvim",
  config = function()
    require("dracula").setup({
      transparent_bg = false,
      italic_comment = false,
    })

    vim.cmd("colorscheme dracula")
  end,
}

return { M }
