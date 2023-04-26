local lspconfig = require("lspconfig")
local lsp = require("lsp-zero").preset {
    name = "recommended",
    set_lsp_keymaps = false,
    manage_nvim_cmp = true,
    suggest_lsp_servers = false,
}

lsp.ensure_installed {
    "rust_analyzer",
    "lua_ls",
    "marksman",
}

lsp.on_attach(function(_, bufnr)
    local opts = {buffer = bufnr, remap = false}

    vim.keymap.set("n", "<leader>ci", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<leader>cd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "<leader>ct", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "<leader>cr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<leader>cs", vim.lsp.buf.signature_help, opts)
end)

lsp.setup()

vim.diagnostic.config {
    virtual_text = true,
    signs = false,
    update_in_insert = true,
}

lspconfig.lua_ls.setup {
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" }
            }
        }
    }
}
