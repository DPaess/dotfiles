-- Markdown rendered in the buffer (headings, tables, callouts, code blocks).
-- Images are drawn by snacks.nvim (snacks.lua); this plugin leaves them alone.
--
-- Shortcut:
--   <leader>mr  toggle rendering (raw markdown <-> rendered)
return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown" },
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<leader>mr", "<cmd>RenderMarkdown toggle<cr>", ft = "markdown", desc = "Markdown: toggle render" },
  },
  opts = {},
}
