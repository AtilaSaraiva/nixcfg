vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Allows moving chuncks of selected text up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Makes the cursor stay in the same place for J
vim.keymap.set("n", "J", "mzJ`z")

-- Keeps cursor in the middle for jumping
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Search terms stay in the middle
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- paste while keeping the previous copy buffer
vim.keymap.set("x", "<leader>p", [["_dP]])

-- copy into the system clipboard : asbjornHaland
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- delete to void register
vim.keymap.set({"n", "v"}, "<leader>d", "\"_d")

-- tmux session manager
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- quickfix shenanigans
vim.keymap.set("n", "<C-q>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-w>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- replace current word
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- make script executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- a way to make custom templates for any file type
vim.keymap.set("n", "<leader><Tab>", '/<++><Enter>"_c4l')
vim.keymap.set("i", "<leader><Tab>", '<Esc>/<++><Enter>"_c4l')
vim.keymap.set("v", "<leader><Tab>", '<Esc>/<++><Enter>"_c4l')

-- Window navigation using :wincmd
vim.keymap.set('n', '<leader>h', '<Cmd>wincmd h<CR>', { desc = 'Move to the left window' })
vim.keymap.set('n', '<leader>j', '<Cmd>wincmd j<CR>', { desc = 'Move to the below window' })
vim.keymap.set('n', '<leader>k', '<Cmd>wincmd k<CR>', { desc = 'Move to the above window' })
vim.keymap.set('n', '<leader>l', '<Cmd>wincmd l<CR>', { desc = 'Move to the right window' })
vim.keymap.set('n', '<leader>p', '<Cmd>wincmd p<CR>', { desc = 'Swap windows' })

vim.keymap.set('t', '<leader>h', '<C-\\><C-N><Cmd>wincmd h<CR>')
vim.keymap.set('t', '<leader>j', '<C-\\><C-N><Cmd>wincmd j<CR>')
vim.keymap.set('t', '<leader>k', '<C-\\><C-N><Cmd>wincmd k<CR>')
vim.keymap.set('t', '<leader>l', '<C-\\><C-N><Cmd>wincmd l<CR>')
vim.keymap.set('i', '<leader>h', '<C-\\><C-N><Cmd>wincmd h<CR>')
vim.keymap.set('i', '<leader>j', '<C-\\><C-N><Cmd>wincmd j<CR>')
vim.keymap.set('i', '<leader>k', '<C-\\><C-N><Cmd>wincmd k<CR>')
vim.keymap.set('i', '<leader>l', '<C-\\><C-N><Cmd>wincmd l<CR>')

-- terminal
vim.keymap.set("n", "<leader>t", '<cmd>terminal<CR>a')
vim.keymap.set("t", "<Esc>", '<C-\\><C-N>')

vim.api.nvim_create_autocmd('TermOpen', {
    group = vim.api.nvim_create_augroup('custom-term-open', { clear = true }),
    callback = function()
        vim.opt.number = false
        vim.opt.relativenumber = false
    end,
})

local job_id = 0
vim.keymap.set("n", "<leader>st", function()
    vim.cmd.vnew()
    vim.cmd.term()
    vim.cmd.wincmd("J")
    vim.api.nvim_win_set_height(0, 10)
    job_id = vim.bo.channel

    vim.cmd('normal! a')
end)

-- Example of how to create a custom terminal command
-- vim.keymap.set("n", "<leader>example", function()
--     vim.fn.chansend(job_id, { "ls -al\r\n" })
-- end)
