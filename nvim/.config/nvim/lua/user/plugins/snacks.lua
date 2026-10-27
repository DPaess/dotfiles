-- Images inline in the terminal via the Kitty graphics protocol (Ghostty, also inside tmux).
-- Only the image module is enabled. PNG works as is; other formats and math need ImageMagick,
-- Mermaid needs mmdc (@mermaid-js/mermaid-cli). `:checkhealth snacks` shows what is missing.
return {
  "folke/snacks.nvim",
  lazy = false,
  opts = {
    image = { enabled = true },
  },
}
