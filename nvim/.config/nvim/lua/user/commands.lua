local cmd = vim.api.nvim_create_user_command

cmd('W', 'w', {})
cmd('WQ', 'wq', {bang = true})
cmd('Wq', 'wq', {bang = true})
cmd('Q', 'q', {bang=true})
cmd('Jq', '%!jq .', {bang=true})

-- ESP-IDF: generate .clangd in project root so clangd finds build/compile_commands.json
-- and strips Xtensa-specific flags it cannot parse.
-- Run once per project after `idf.py build` has been executed.
cmd('ESPIDFInit', function()
    local path = vim.fn.getcwd() .. "/.clangd"
    if vim.fn.filereadable(path) == 1 then
        vim.notify(".clangd already exists in " .. vim.fn.getcwd(), vim.log.levels.WARN)
        return
    end
    local f = io.open(path, "w")
    if not f then
        vim.notify("Could not create .clangd", vim.log.levels.ERROR)
        return
    end
    f:write([[
CompileFlags:
  CompilationDatabase: build/
  Remove:
    - -mlongcalls
    - -mtext-section-literals
    - -fno-tree-switch-conversion
    - -fstrict-volatile-bitfields
    - -fno-jump-tables
]])
    f:close()
    vim.notify(".clangd created — make sure `idf.py build` has been run first", vim.log.levels.INFO)
end, { nargs = 0 })
