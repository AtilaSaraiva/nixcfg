require'nvim-treesitter.configs'.setup {
    ensure_installed = { 
        "julia",
        "fortran",
        "bash",
        "c",
        "lua",
        "vim",
        "vimdoc",
        "query",
        "markdown",
        "markdown_inline"
    },

    sync_install = true,
    
    auto_install = false,
    
    ignore_install = { "javascript" },
    
    highlight = {
        enable = true,
    
        additional_vim_regex_highlighting = false,
    },
}
