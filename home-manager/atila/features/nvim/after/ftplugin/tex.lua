-- copies the last equation bellow
vim.keymap.set("n", "<leader>n", "?end{equation<CR>V?begin{equation<CR>y<C-o><C-o>p")

vim.keymap.set("n", "<leader>wc", "<cmd>VimtexCountWords<CR>")

vim.keymap.set("n", "<leader>ll", "<cmd>VimtexCompile<CR>")
