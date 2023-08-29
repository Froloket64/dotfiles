require("nvim-treesitter.configs").setup {
    -- Parsers to be installed 
    ensure_installed = {
        "rust",
        "javascript",
        "python",
        "c",
        "lua",
        "vim",
        "vimdoc",
        "query",
        "markdown",
    },

    -- Install parsers synchronously
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    auto_install = true,

    -- List of parsers to ignore installing (for "all")
    ignore_install = {},

    highlight = {
        enable = true,

        -- List of parsers to disable
        disable = {},

        -- Disable treesitter highlight for large files
        -- disable = function(lang, buf)
            --     local max_filesize = 100 * 1024 -- 100 KB
            --     local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            --     if ok and stats and stats.size > max_filesize then
            --         return true
            --     end
            -- end,

        additional_vim_regex_highlighting = false
    },
}
