local navbuddy = require("nvim-navbuddy")
local lspconfig = require("lspconfig")
local rust_tools = require("rust-tools")
local lsp_format = require("lsp-format")
local lsp = require("lsp-zero").preset {
    name = "recommended",
    set_lsp_keymaps = false,
    manage_nvim_cmp = true,
    suggest_lsp_servers = false,
}

lsp_format.setup()

lsp.on_attach(function(client, bufnr)
    -- Maps
    local opts = { buffer = bufnr, remap = false }

    lsp_format.on_attach(client, bufnr)

    vim.keymap.set("n", "<leader>ci", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<leader>cd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "<leader>ct", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "<leader>cr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<leader>cs", vim.lsp.buf.signature_help, opts)

    vim.keymap.set("n", "<leader>g.", function() vim.cmd [[Navbuddy]] end, opts)

    lsp.default_keymaps()

    -- Navbuddy
    navbuddy.attach(client, bufnr)
end)

lsp.setup()

vim.diagnostic.config {
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = true,
    severity_sort = true,
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

lspconfig.hls.setup {
    filetypes = {
        "haskell",
        "lhaskell",
        "cabal",
    },
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
    dap = {
        adapter = {
            type = "executable",
            command = "lldb-vscode",
            name = "rt_debug",
        },
    },
}

local mason = require("mason-lspconfig")

mason.setup {
    ensure_installed = {
        "rust_analyzer",
        "lua_ls",
        "marksman",
        "pylsp",
        "bashls",
        "vimls",
        "cssls",
        "hls",
    },
    handlers = {
        lsp.default_setup,
    },
}
