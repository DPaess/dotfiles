-- Follow Claude Code from Neovim. Claude runs in a tmux pane; its follow mod calls
-- follow() over this Neovim's socket the moment it edits a file. The keys below talk
-- back to that pane: pause, continue, ask about a selection.
--   <leader>cp  pause Claude (Esc in its pane)
--   <leader>cc  continue, telling Claude which files you saved meanwhile
--   <leader>ca  ask about the selection (visual) or the current line
--   <leader>cf  follow on/off (also :ClaudeFollow)
local M = {}

M.enabled = true -- jump to Claude's edits
M.pane = nil     -- Claude's tmux pane, told by the follow mod on each edit
M.saved = {}     -- files you saved since your last "continue" (absolute paths, for Claude)

local ns = vim.api.nvim_create_namespace("claude_follow")

-- scheduled, so a message too long for the command line never blocks the caller with "Press ENTER"
local function notify(msg, level)
    vim.schedule(function() vim.notify(msg, level or vim.log.levels.INFO, { title = "Claude" }) end)
end

local function short(path)
    return vim.fn.fnamemodify(path, ":~:.")
end

-- Called by the follow mod: Claude just wrote lines first..last of file (first 0: no range).
function M.follow(file, first, last, pane)
    if pane and pane ~= "" then
        M.pane = pane
    end

    local buf = vim.fn.bufadd(file)
    vim.bo[buf].buflisted = true -- kept in the buffer bar, never closed

    if vim.bo[buf].modified then
        notify("Claude edited " .. short(file) .. ", where you have unsaved changes", vim.log.levels.WARN)
        return 0
    end
    if vim.api.nvim_buf_is_loaded(buf) then
        vim.cmd.checktime(buf) -- reload now, not on the next focus
    else
        vim.fn.bufload(buf)
    end

    -- never pull the window away while you are typing, selecting or have unsaved work in it
    local busy = vim.api.nvim_get_mode().mode ~= "n" or vim.bo.modified or vim.bo.buftype ~= ""
    if not M.enabled then
        return 0
    end
    if busy then
        notify("Claude edited " .. short(file) .. (first > 0 and (":" .. first) or ""))
        return 0
    end

    local prev = vim.api.nvim_get_current_buf()
    vim.api.nvim_win_set_buf(0, buf)
    -- drop the empty [No Name] buffer Neovim starts with, so the bar shows only files
    if prev ~= buf and vim.api.nvim_buf_get_name(prev) == "" and vim.api.nvim_buf_line_count(prev) == 1
        and vim.api.nvim_buf_get_lines(prev, 0, 1, false)[1] == "" then
        vim.api.nvim_buf_delete(prev, {})
    end
    if first > 0 then
        local count = vim.api.nvim_buf_line_count(buf)
        first = math.min(first, count)
        last = math.min(math.max(last, first), count)
        vim.api.nvim_win_set_cursor(0, { first, 0 })
        vim.cmd("normal! zz")
        vim.hl.range(buf, ns, "IncSearch", { first - 1, 0 }, { last - 1, 0 }, { regtype = "V", timeout = 1500 })
    end
    return 1
end

local function tmux(args, stdin)
    return vim.system(vim.list_extend({ "tmux" }, args), { text = true, stdin = stdin }):wait()
end

-- Claude's pane: the one the mod named, else a pane running claude in this window, then this session.
local function claude_pane(callback)
    if M.pane and tmux({ "display", "-p", "-t", M.pane, "#{pane_id}" }).code == 0 then
        return callback(M.pane)
    end
    for _, scope in ipairs({ {}, { "-s" } }) do
        local args = vim.list_extend({ "list-panes", "-F", "#{pane_id}\t#{pane_current_command}\t#{pane_current_path}" }, scope)
        local panes = {}
        for line in (tmux(args).stdout or ""):gmatch("[^\n]+") do
            local id, cmd, path = line:match("^(%S+)\t(%S+)\t(.*)$")
            if cmd == "claude" then
                table.insert(panes, { id = id, path = path })
            end
        end
        if #panes == 1 then
            M.pane = panes[1].id
            return callback(M.pane)
        elseif #panes > 1 then
            return vim.ui.select(panes, {
                prompt = "Which Claude?",
                format_item = function(p) return p.id .. "  " .. short(p.path) end,
            }, function(p)
                if p then
                    M.pane = p.id
                    callback(p.id)
                end
            end)
        end
    end
    notify("no Claude pane found in this tmux session", vim.log.levels.WARN)
end

-- Paste text into Claude's prompt as one block and submit it; while Claude works, it is queued.
local function send(text)
    claude_pane(function(pane)
        tmux({ "load-buffer", "-b", "nvim-claude", "-" }, text)
        tmux({ "paste-buffer", "-p", "-d", "-b", "nvim-claude", "-t", pane })
        vim.defer_fn(function() tmux({ "send-keys", "-t", pane, "Enter" }) end, 150)
    end)
end

function M.pause()
    claude_pane(function(pane)
        tmux({ "send-keys", "-t", pane, "Escape" })
        notify("paused")
    end)
end

function M.continue()
    local files = vim.tbl_keys(M.saved)
    table.sort(files)
    M.saved = {}
    if #files == 0 then
        return send("Continue.")
    end
    send("Continue. While paused I edited: " .. table.concat(files, ", ")
        .. ". Read them, review my changes, ask me if something is unclear, otherwise carry on.")
end

-- Ask about lines first..last of the current buffer; the answer comes in Claude's pane.
function M.ask(first, last)
    local buf = vim.api.nvim_get_current_buf()
    local file = vim.api.nvim_buf_get_name(buf)
    if file == "" then
        return notify("this buffer has no file", vim.log.levels.WARN)
    end
    local code = table.concat(vim.api.nvim_buf_get_lines(buf, first - 1, last, false), "\n")
    vim.ui.input({ prompt = "Ask Claude: " }, function(comment)
        if not comment or comment == "" then
            return
        end
        local range = first == last and tostring(first) or (first .. "-" .. last)
        send(("About %s:%s: %s\n\n```%s\n%s\n```"):format(vim.fn.fnamemodify(file, ":p"), range, comment, vim.bo[buf].filetype, code))
    end)
end

function M.toggle()
    M.enabled = not M.enabled
    notify("follow " .. (M.enabled and "on" or "off"))
end

vim.api.nvim_create_autocmd("BufWritePost", {
    group = vim.api.nvim_create_augroup("claude_follow", {}),
    callback = function(args)
        M.saved[vim.fn.fnamemodify(args.file, ":p")] = true
    end,
})

vim.api.nvim_create_user_command("ClaudeFollow", M.toggle, {})

local opts = { silent = true }
vim.keymap.set("n", "<leader>cp", M.pause, opts)
vim.keymap.set("n", "<leader>cc", M.continue, opts)
vim.keymap.set("n", "<leader>cf", M.toggle, opts)
vim.keymap.set("n", "<leader>ca", function()
    local line = vim.fn.line(".")
    M.ask(line, line)
end, opts)
vim.keymap.set("x", "<leader>ca", function()
    local a, b = vim.fn.line("v"), vim.fn.line(".")
    vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "nx", false)
    M.ask(math.min(a, b), math.max(a, b))
end, opts)

return M
