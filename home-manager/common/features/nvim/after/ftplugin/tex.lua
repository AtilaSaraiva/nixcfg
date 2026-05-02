-- copies the last equation bellow
vim.keymap.set("n", "<leader>n", "?end{equation<CR>V?begin{equation<CR>y<C-o><C-o>p")

-- creates a fold for the current environment
vim.keymap.set("n", "<leader>fl", [[/\\end{<CR>f{lyawA %}}}<Esc>?\\begin{<C-r>"}<CR>A %{{{<Esc>
]])

vim.keymap.set("n", "<leader>wc", "<cmd>VimtexCountWords<CR>")

vim.keymap.set("n", "<leader>ll", "<cmd>VimtexCompile<CR>")
