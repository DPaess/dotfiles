local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

local yank_group = augroup('highlight_yank', {})
local relative_number = augroup('relative_number', {})
local cursor_line = augroup('cursor_line', {})
local pavani = augroup('pavani', {})


-- highlight yanked text
autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.hl.on_yank({
            higroup = 'IncSearch',
            timeout = 50,
        })
    end,
})

-- make all windows (almost) equally high and wide when vim window is resized.
autocmd('VimResized', {
    group = pavani,
    pattern = '*',
    command = 'execute "normal! \\<c-w>="',
})

-- before every save: format Go and Lua, trim trailing whitespace (Markdown keeps its two-space line breaks).
-- A pre-write hook, not a write replacement, so LSP save notifications and other plugins' hooks still fire.
-- Root-owned files: :W (commands.lua) falls back to sudo.
autocmd("BufWritePre", {
    group = pavani,
    pattern = "*",
    callback = function(args)
        local ft = vim.bo[args.buf].filetype
        if ft == "oil" then
            return
        end

        if (ft == "go" or ft == "lua")
            and #vim.lsp.get_clients({ bufnr = args.buf, method = "textDocument/formatting" }) > 0 then
            vim.lsp.buf.format({ bufnr = args.buf, async = false, timeout_ms = 3000 })
        end

        if ft ~= "markdown" then
            local view = vim.fn.winsaveview()
            vim.cmd([[keeppatterns %s/\s\+$//e]])
            vim.fn.winrestview(view)
        end
    end,
})

-- relative numbers in insert mode
autocmd({ "BufEnter", "FocusGained", "InsertLeave" }, {
    group = relative_number,
    pattern = "*",
    callback = function()
        if vim.bo.filetype == "term" then
            return
        end
        vim.opt.relativenumber = true
    end
})
autocmd({ "BufLeave", "FocusLost", "InsertEnter" }, {
    group = relative_number,
    pattern = "*",
    command = 'set norelativenumber',
})


-- highlight cursor line
autocmd({ "VimEnter", "WinEnter", "BufWinEnter" }, {
    group = cursor_line,
    pattern = "*",
    command = 'setlocal cursorline',
})
autocmd({ "WinLeave" }, {
    group = cursor_line,
    pattern = "*",
    command = 'setlocal nocursorline',
})

autocmd({ "TermOpen" }, {
    group = pavani,
    callback = function()
        vim.opt_local.number = false
        vim.bo.filetype = "term"
        vim.opt_local.relativenumber = false
        vim.opt_local.signcolumn = "no"
        vim.cmd("startinsert")
    end,
})


