vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.keymap.set('n', '<S-h>', vim.cmd.bprevious)
vim.keymap.set('n', '<S-l>', vim.cmd.bnext)
vim.keymap.set('n', '<leader>bd', vim.cmd.bd)
vim.keymap.set('n', '<leader>|', vim.cmd.vsplit)
vim.keymap.set('n', '<leader>q', vim.cmd.q)
-- save filename
vim.keymap.set({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>")
-- Move Lines
vim.keymap.set("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
vim.keymap.set("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
vim.keymap.set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
vim.keymap.set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
vim.keymap.set("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
vim.keymap.set("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })
