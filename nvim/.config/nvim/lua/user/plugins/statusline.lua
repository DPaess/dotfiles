local M = {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },

    config = function()
        require('lualine').setup {
            options = {
                theme                = 'dracula',
                component_separators = '',
                section_separators   = { left = '', right = '' },
            },
        }
    end
}

return { M }
