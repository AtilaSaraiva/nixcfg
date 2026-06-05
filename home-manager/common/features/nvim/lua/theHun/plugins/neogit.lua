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
      kind = "floating",
    },
    floating = {
      relative = "editor",
      width = 0.8,   -- 80% of screen width
      height = 1.0,  -- 100% of screen height
      border = "single",
    },
  },
  config = function(_, opts)
    require("neogit").setup(opts)

    -- Neogit only computes a centered position for floats, and floating.col
    -- is a static number (no fraction/function support), so right-aligning
    -- responsively means nudging the window after it opens. Keys off the
    -- public NeogitCommitView filetype and core nvim APIs only; the pcall
    -- makes it degrade to the default centered float if anything upstream
    -- changes, rather than erroring.
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "NeogitCommitView",
      callback = function()
        pcall(function()
          local win = vim.api.nvim_get_current_win()
          local cfg = vim.api.nvim_win_get_config(win)
          if cfg.relative == "" or not cfg.width then return end -- not a float
          cfg.col = vim.o.columns - cfg.width - 2 -- -2 leaves room for the border
          cfg.row = 0
          vim.api.nvim_win_set_config(win, cfg)
        end)
      end,
    })
  end,
}
