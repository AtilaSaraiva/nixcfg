vim.opt.conceallevel = 2

vim.keymap.set("n", "<leader>oo", "<cmd>ObsidianNew<CR>")

vim.keymap.set("n", "<leader>on", "<cmd>ObsidianQuickSwitch<CR>")

vim.cmd([[cnoreabbrev oo ObsidianNew]])
