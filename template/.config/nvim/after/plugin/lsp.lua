local lsp = require("lsp-zero").preset {
    name = "recommended",
    set_lsp_keymaps = true,
    manage_nvim_cmp = true,
    suggest_lsp_servers = false,
}

vim.diagnostic.config {
    virtual_text = true,
}

lsp.ensure_installed {
    "rust_analyzer",
    "lua_ls"
}

lsp.setup()
