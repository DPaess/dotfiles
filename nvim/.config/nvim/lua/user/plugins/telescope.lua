return {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        require('telescope').setup {
            defaults = {
                path_display = { "truncate" }
            }
        }

        local keymap = vim.keymap.set
        local opts = { silent = true }
        local builtin = require("telescope.builtin")
        keymap("n", "<leader>ff", builtin.find_files, opts)
        keymap("n", "<leader>fg", builtin.live_grep, opts)
        keymap("n", "<leader>fe", builtin.diagnostics, opts)
        keymap("n", "<leader>fr", builtin.lsp_references, opts)
        keymap("n", "<leader>fi", builtin.lsp_implementations, opts)
        keymap("n", "<leader>fd", builtin.lsp_definitions, opts)
    end
}
