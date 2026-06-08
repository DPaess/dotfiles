local M = {
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

            vim.lsp.enable({
                "lua_ls",
                "clangd",
                "pyright",
                "gopls",
            })

            --AUTOMATIC LSP
            vim.diagnostic.config({
                virtual_text = true,
            })
        end,
    },
}

return M
