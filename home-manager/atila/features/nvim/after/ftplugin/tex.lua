-- copies the last equation bellow
vim.keymap.set("n", "<leader>n", "?end{equation<CR>vipy<C-o>p<CR>")

vim.keymap.set("n", "<leader>wc", "<cmd>VimtexCountWords<CR>")

vim.keymap.set("n", "<leader>ll", "<cmd>VimtexCompile<CR>")
