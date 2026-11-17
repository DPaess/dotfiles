return {
    {
        "mason-org/mason.nvim",
        config = function()
            require("mason").setup()

            -- auto-install the tree-sitter CLI (nvim-treesitter main branch builds parsers from source)
            local registry = require("mason-registry")
            registry.refresh(function()
                if not registry.is_installed("tree-sitter-cli") then
                    registry.get_package("tree-sitter-cli"):install()
                end
            end)
        end,
    },

    -- lua_ls for the Neovim config: loads only the modules you require, instead of every plugin at startup
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {},
    },

    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
        },

        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "clangd",
                    "pyright",
                    "gopls",
                    "arduino_language_server",
                    "ts_ls",
                    "html",
                    "cssls",
                },
                -- v2 auto-enables installed servers via vim.lsp.enable().
                -- Exclude arduino_language_server: Arduino-Nvim sets it up itself.
                automatic_enable = {
                    exclude = { "arduino_language_server" },
                },
            })

            -- Only servers with settings of their own are configured here; blink.cmp adds its
            -- completion capabilities to every server itself (Neovim 0.11+).

            vim.lsp.config("lua_ls", {
                settings = {
                    Lua = {
                        runtime = { version = "LuaJIT" },
                        telemetry = { enable = false },
                    },
                },
            })

            vim.lsp.config("clangd", {
                cmd = { "clangd", "--background-index" },
            })

            vim.lsp.config("gopls", {
                settings = {
                    gopls = {
                        gofumpt = true,
                        staticcheck = true,
                    },
                },
            })

            vim.diagnostic.config({
                virtual_text = true,
            })
        end,
    },
}
