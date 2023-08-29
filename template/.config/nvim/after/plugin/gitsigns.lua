require("gitsigns").setup {
    signs = {
        add          = { text = "│" },
        change       = { text = "│" },
        delete       = { text = "│" },
        topdelete    = { text = '│' },
        changedelete = { text = '│' },
        untracked    = { text = "│" },
    },
    signcolumn = true,
    word_diff = false,
}
