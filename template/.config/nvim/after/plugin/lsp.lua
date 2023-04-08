local lsp = require("lsp-zero").preset {
    name = "recommended",
    set_lsp_keymaps = true,
    manage_nvim_cmp = true,
    suggest_lsp_servers = false,
}

lsp.ensure_installed {
    "rust_analyzer",
    "lua_ls",
    "marksman",
}

lsp.setup()

vim.diagnostic.config {
    virtual_text = true,
    signs = false,
    update_in_insert = true,
}
