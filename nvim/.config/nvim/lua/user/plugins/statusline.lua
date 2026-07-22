return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },

    config = function()
        require('lualine').setup {
            options = {
                theme                = 'dracula',
                component_separators = '',
                section_separators   = { left = '', right = '' },
            },
            sections = {
                lualine_c = {
                    {
                        'filename',
                        path = 1, -- 1 = relative to cwd, 2 = absolute, 3 = absolute with ~ for home
                    },
                },
            },
        }
    end
}
