local M = {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        local configs = require("nvim-treesitter.configs")

        configs.setup(
            {
                ensure_installed = { "lua", "vim", "vimdoc", "query", "python", "c", "cpp", "markdown", "markdown_inline", "go", "rust", "toml" },
                sync_install = false,
                highlight = { enable = true },
                indent = { enable = true },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = '<leader>v',
                        scope_incremental = '<CR>',
                        node_incremental = '<TAB>',
                        node_decremental = '<S-TAB>',
                    }
                }
            }
        )
    end
}

return { M }
