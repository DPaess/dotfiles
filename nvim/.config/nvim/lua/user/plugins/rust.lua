-- rust-analyzer must be available via rustup:
--   rustup component add rust-analyzer
return {
    "mrcjkb/rustaceanvim",
    version = "^5",
    lazy = false,
    config = function()
        vim.g.rustaceanvim = {
            server = {
                capabilities = require("blink.cmp").get_lsp_capabilities(),
                settings = {
                    ["rust-analyzer"] = {
                        cargo = { allFeatures = true },
                        check = { command = "clippy" },
                    },
                },
            },
        }
    end,
}
