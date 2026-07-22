return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },

    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
            "saghen/blink.cmp",
        },

        config = function()
            local capabilities = require("blink.cmp").get_lsp_capabilities()

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

            -- LUA
            vim.lsp.config("lua_ls", {
                capabilities = capabilities,
                settings = {
                    Lua = {
                        runtime = {
                            version = "LuaJIT",
                        },
                        diagnostics = {
                            globals = { "vim" },
                        },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false,
                        },
                        telemetry = {
                            enable = false,
                        },
                    },
                },
            })

            -- C/C++
            vim.lsp.config("clangd", {
                capabilities = capabilities,
                cmd = {
                    "clangd",
                    "--background-index",
                },
            })

            -- Python
            vim.lsp.config("pyright", {
                capabilities = capabilities,
            })

            -- Go
            vim.lsp.config("gopls", {
                capabilities = capabilities,
                settings = {
                    gopls = {
                        gofumpt = true,
                        staticcheck = true,
                    },
                },
            })

            -- JS/TS
            vim.lsp.config("ts_ls", {
                capabilities = capabilities,
            })

            -- HTML
            vim.lsp.config("html", {
                capabilities = capabilities,
            })

            -- CSS
            vim.lsp.config("cssls", {
                capabilities = capabilities,
            })

            -- Servers are enabled by mason-lspconfig's automatic_enable (above).

            vim.diagnostic.config({
                virtual_text = true,
            })
        end,
    },
}
