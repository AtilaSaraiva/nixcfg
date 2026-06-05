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
      width = 0.8,   -- 60% of screen width
      height = 1.0,  -- 80% of screen height
      border = "single",
    },
  },
}
