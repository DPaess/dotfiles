local opts = { silent = true }
local keymap = vim.keymap.set

-- disable arrow keys
keymap("n", "<Up>", "<Nop>", opts)
keymap("n", "<Down>", "<Nop>", opts)
keymap("n", "<Left>", "<Nop>", opts)
keymap("n", "<Right>", "<Nop>", opts)

-- faster scroll with C-e C-y
keymap("n", "<C-y>", "5<C-y>", opts)
keymap("n", "<C-e>", "5<C-e>", opts)

-- move lines with <C-j><C-h>
keymap("n", "<C-j>", ":m .+1<CR>==", opts)
keymap("n", "<C-k>", ":m .-2<CR>==", opts)
keymap("i", "<C-j>", "<Esc>:m .+1<CR>==gi", opts)
keymap("i", "<C-k>", "<Esc>:m .-2<CR>==gi", opts)
keymap("v", "<C-j>", ":m '>+1<CR>gv=gv", opts)
keymap("v", "<C-k>", ":m '<-2<CR>gv=gv", opts)

-- keep cursor centered on jumping to next/previos and joining lines
keymap("n", "N", "Nzzzv", opts)
keymap("n", "n", "nzzzv", opts)
keymap("n", "J", "mzJ`z", opts)

-- insert undo checkpoints on symbols
keymap("i", ",", ",<c-g>u", opts)
keymap("i", ".", ".<c-g>u", opts)
keymap("i", "!", "!<c-g>u", opts)
keymap("i", "?", "?<c-g>u", opts)
keymap("i", '"', '"<c-g>u', opts)
keymap("i", "'", "'<c-g>u", opts)

-- lsp
-- Neovim 0.11+ ships native LSP maps: grn (rename), gra (code action),
-- grr (references), gri (implementation), K (hover), [d/]d + <C-w>d (diagnostics).
-- Only the maps below have no native equivalent.
keymap("n", "<leader>gd", vim.lsp.buf.definition, opts)
keymap("n", "<leader>lf", vim.lsp.buf.format, opts)

-- copy
keymap("n", "<leader>y", '"+y', opts)
keymap("v", "<leader>y", '"+y', opts)
-- paste
keymap("n", "<leader>p", '"+p', opts)
keymap("v", "<leader>p", '"+p', opts)
keymap("x", "<leader>P", '"_dP', opts)
