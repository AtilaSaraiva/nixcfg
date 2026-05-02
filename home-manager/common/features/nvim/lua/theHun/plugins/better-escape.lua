return {
  "max397574/better-escape.nvim",
  config = function()
      require("better_escape").setup {
          timeout = vim.o.timeoutlen, -- after `timeout` passes, you can press the escape key and the plugin will ignore it
          default_mappings = false, -- setting this to false removes all the default mappings
          mappings = {
              -- i for insert
              i = {
                  k = {
                      -- These can all also be functions
                      j = "<Esc>",
                  },
              },
              c = {
                  k = {
                      j = "<C-c>",
                  },
              },
              t = {
                  k = {
                      j = "<C-\\><C-n>",
                  },
              },
              v = {
                  k = {
                      j = "<Esc>",
                  },
              },
              s = {
                  k = {
                      j = "<Esc>",
                  },
              },
          },
      }
  end,
}
