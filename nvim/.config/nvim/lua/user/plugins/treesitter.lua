-- nvim-treesitter `main` branch (required for Neovim 0.11+/0.12).
-- The old `master` branch is frozen and crashes on 0.12 (query_predicates.lua),
-- notably when opening markdown with fenced code blocks.
return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter").setup({})

        -- Parsers are installed asynchronously; `main` has no `ensure_installed`.
        -- Keep both markdown + markdown_inline for fenced-code injections.
        require("nvim-treesitter").install({
            "lua", "vim", "vimdoc", "query", "python", "c", "cpp",
            "markdown", "markdown_inline", "go", "rust", "toml",
            "javascript", "typescript", "html", "css", "json",
        })

        -- Highlighting: the module system is gone; enable per-buffer.
        -- pcall so a filetype without an installed parser never errors the buffer.
        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("user_treesitter_highlight", {}),
            callback = function(args)
                pcall(vim.treesitter.start, args.buf)
            end,
        })
    end,
}
