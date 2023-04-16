require("hop").setup {
    keys = "etovxqpdygfblzhckisuran",
}

vim.keymap.set("n", "gw", ":HopWord<cr>")
vim.keymap.set("n", "gz", ":HopChar1<cr>")
