return {
    -- `branch` is pinned deliberately. Upstream moved its default branch to the
    -- `main` rewrite, so an unpinned spec silently migrates the plugin on the
    -- next :Lazy sync. Naming it keeps the switch explicit and reversible.
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    build = ':TSUpdate'
}
