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
            sections = {
                lualine_c = {
                    {
                        'filename',
                        path = 1, -- 1 = relativo ao cwd, 2 = absoluto, 3 = absoluto com ~ no home
                    },
                },
            },
        }
    end
}

return { M }
