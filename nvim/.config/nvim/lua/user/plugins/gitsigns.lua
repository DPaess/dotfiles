-- Changed lines in the sign column, hunk navigation and staging, line blame.
return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    on_attach = function(bufnr)
      local gs = require("gitsigns")
      local map = function(lhs, rhs, desc)
        vim.keymap.set("n", lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
      end
      -- ]c/[c keep their diff-mode meaning inside diffs
      map("]c", function()
        if vim.wo.diff then vim.cmd.normal({ "]c", bang = true }) else gs.nav_hunk("next") end
      end, "next hunk")
      map("[c", function()
        if vim.wo.diff then vim.cmd.normal({ "[c", bang = true }) else gs.nav_hunk("prev") end
      end, "previous hunk")
      map("<leader>hs", gs.stage_hunk, "stage hunk")
      map("<leader>hr", gs.reset_hunk, "reset hunk")
      map("<leader>hp", gs.preview_hunk, "preview hunk")
      map("<leader>hb", function() gs.blame_line({ full = true }) end, "blame line")
      map("<leader>tb", gs.toggle_current_line_blame, "toggle inline blame")
    end,
  },
}
