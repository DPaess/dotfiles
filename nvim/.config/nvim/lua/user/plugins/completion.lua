return {
    "saghen/blink.cmp",
    version = "1.*",

    dependencies = {
        "rafamadriz/friendly-snippets",
    },

    build = "cargo build --release",

    -- Configuration for blink.cmp including keymaps, appearance, completion behavior, and sources
    opts = {
        keymap = {
            preset = "default",
            -- disable a keymap from the preset
            ['<C-k>'] = false,
        },

        signature = { enabled = true },

        completion = {
            documentation = { auto_show = true },
        },

        cmdline = {
            completion = {
                menu = { auto_show = true },
            },

            sources = function()
                local type = vim.fn.getcmdtype()

                -- search in buffer
                if type == "/" or type == "?" then
                    return { "buffer" }
                end

                -- command mode
                if type == ":" then
                    return { "cmdline", "path" }
                end

                return {}
            end,
        },
    },
}
