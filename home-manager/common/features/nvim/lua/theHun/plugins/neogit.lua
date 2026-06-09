return {
  "NeogitOrg/neogit",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",         -- required

    "esmuellert/codediff.nvim",      -- optional

    "nvim-telescope/telescope.nvim", -- optional
  },
  cmd = "Neogit",
  keys = {
    { "<leader>gg", "<cmd>Neogit<cr>", desc = "Show Neogit UI" }
  },
  opts = {
    commit_view = {
      kind = "vsplit",
    },
  },
  config = function(_, opts)
    require("neogit").setup(opts)

    -- Neogit's vsplit opens at the default ~50% width with no option to size
    -- it as a fraction of the screen, so widen the window to 80% after it
    -- opens. Keys off the public NeogitCommitView filetype and core nvim APIs
    -- only; the pcall makes it degrade to the default-width split if anything
    -- upstream changes, rather than erroring.
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "NeogitCommitView",
      callback = function()
        pcall(function()
          local win = vim.api.nvim_get_current_win()
          if vim.api.nvim_win_get_config(win).relative ~= "" then return end -- a float, not a split
          vim.api.nvim_win_set_width(win, math.floor(vim.o.columns * 0.8))
        end)
      end,
    })
  end,
}
