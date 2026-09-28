-- nvim-treesitter's `main` branch is a full rewrite, not an update: `setup()`
-- accepts only `install_dir`, so the old `ensure_installed` / `highlight` /
-- `sync_install` keys are read by nothing. Parser installation and highlighting
-- are both driven explicitly now. See `:h nvim-treesitter-commands`.
--
-- The `master` branch is not an option here: its query directives still expect
-- a single TSNode per capture, while Nvim 0.12 hands them a TSNode list, so
-- markdown injections crash. Upstream supports master only up to Nvim 0.11.

local ts = require("nvim-treesitter")

ts.setup()

-- Installs asynchronously and no-ops for parsers already present. Building a
-- missing grammar shells out to the `tree-sitter` CLI and a C compiler, both of
-- which come from home.packages (see ../../default.nix).
ts.install {
  "julia",
  "fortran",
  "bash",
  "c",
  "lua",
  "vim",
  "vimdoc",
  "query",
  "markdown",
  "markdown_inline",
}

-- `main` never enables highlighting itself; Nvim provides it through
-- `vim.treesitter.start()`. Starting it for any buffer that has a parser
-- reproduces master's `highlight = { enable = true }`, without hand-maintaining
-- a filetype->parser mapping (the two differ: `vimdoc` is filetype `help`, and
-- `markdown_inline` is injection-only with no filetype at all).
--
-- On 0.12 `get_parser` returns nil rather than throwing when the language has no
-- parser, so it doubles as the availability check.
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    if vim.treesitter.get_parser(args.buf) then
      vim.treesitter.start(args.buf)
    end
  end,
})
