local navbuddy = require("nvim-navbuddy")
local lspconfig = require("lspconfig")
local rust_tools = require("rust-tools")
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
    "pyright",
    "bashls",
    "vimls",
    "cssls",
    "hls",
}

lsp.on_attach(function(client, bufnr)
    -- Remaps
    local opts = {buffer = bufnr, remap = false}

    vim.keymap.set("n", "<leader>ci", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<leader>cd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "<leader>ct", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "<leader>cr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<leader>cs", vim.lsp.buf.signature_help, opts)

    -- Navbuddy
    navbuddy.attach(client, bufnr)
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

lspconfig.rust_analyzer.setup {
    settings = {
        ["rust_analyzer"] = {
            inlayHints = {
                parameterHints = {
                    enable = true
                },
            },
            context_support = true,
        }
    }
}

rust_tools.setup {
    tools = {
        inlay_hints = {
            auto = true,
            show_parameter_hints = false,
            parameter_hints_prefix = ": ",
            other_hints_prefix = ": ",
        },
    },
}
