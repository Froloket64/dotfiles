-- Bootstrap `lazy.nvim`
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system {
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath
    }
end

vim.opt.rtp:prepend(lazypath)

-- Returns a function that runs `f` if `condition` is true,
-- otherwise calls `fallback`
local function map_or_fallback(condition, f)
    return function(fallback)
        if condition() then
            f()
        else
            fallback()
        end
    end
end

-- Configure plugins
require("lazy").setup {
    { "ellisonleao/gruvbox.nvim", lazy = true, priority = 9999 },
    {
        "nvim-lualine/lualine.nvim",
        config = function()
            require("lualine").setup {
                options = {
                    component_separators = { left = "∘︎", right = "*" },
                    section_separators = { left = "", right = "" },
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch", "diff" },
                    lualine_c = { "filename" },

                    lualine_x = { "diagnostics" },
                    lualine_y = { "filetype" },
                    lualine_z = {},
                },
            }
        end,
        dependencies = { "kyazdani42/nvim-web-devicons" }
    },
    { "max397574/better-escape.nvim", event = "InsertEnter", opts = {} },
    { "ecthelionvi/NeoColumn.nvim", opts = { always_on = true } },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        config = function()
            require("ibl").setup {
                scope = {
                    enabled = false,
                    show_start = false,
                    show_end = false,
                }
           }
        end
    },
    { "numToStr/Comment.nvim", opts = { ignore = "^$" } },
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        opts = {}
    },
    {
        "simonmclean/triptych.nvim",
        keys = {
            {
                "<leader>-",
                ":Triptych<CR>",
                desc = "Open file manager",
            },
        },
        opts = {
            mappings = {
                copy = "y",
                cd = "c",
            },
        },
        dependencies = {
            "nvim-lua/plenary.nvim", -- required
            "nvim-tree/nvim-web-devicons", -- optional
        }
    },
    {
        "chrisgrieser/nvim-spider",
        keys = { "w", "e", "b" },
        -- lazy = true,
        config = function()
            local spider = require("spider")

            vim.keymap.set({ "n", "o", "x" }, "w", function() spider.motion("w") end)
            vim.keymap.set({ "n", "o", "x" }, "e", function() spider.motion("e") end)
            vim.keymap.set({ "n", "o", "x" }, "b", function() spider.motion("b") end)
            vim.keymap.set({ "n", "o", "x" }, "ge", function() spider.motion("ge") end)
        end
    },
    {
        "Makaze/watch.nvim",
        cmd = { "WatchStart", "WatchStop", "WatchFile" },
        opts = {
            split = {
                enabled = true,
                focus = true,
                position = "right",
            }
        }
    },
    {
        "tomiis4/hypersonic.nvim",
        cmd = "Hypersonic",
        opts = {},
    },
    {
        "echasnovski/mini.pick",
        opts = {},
    },

    {
        "zk-org/zk-nvim",
        config = function()
            require("zk").setup {
                picker = "minipick",
                auto_attach = {
                    enabled = true,
                    filetypes = { "markdown" },
                }
            }
        end,
    },

    -- Tree-sitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup {
                ensure_installed = { "lua", "rust", "c", "python", "markdown" },
                auto_install = false,
                highlight = {
                    enable = true,
                    disable = { "rust", "lua" },
                },
                indent = { enable = false },
            }
        end
    },

    -- LSP
    {
        "neovim/nvim-lspconfig",
        ft = { "lua", "rust", "markdown" },
        config = function()
            local lspconfig = require("lspconfig")

            lspconfig.lua_ls.setup {
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" },
                        },
                        completion = {
                            callSnippet = "Replace",
                            displayContext = 5,
                        },
                        format = {
                            enable = false,
                            -- Why tf does this not work?
                            defaultConfig = {
                                call_arg_parentheses = "remove_table_only",
                                max_line_length = "80",
                                trailing_table_separator = "smart",
                                align_continuous_assign_statement = "false",
                            },
                        },
                        hint = {
                            enable = true,
                            arrayIndex = "Disable",
                            paramName = "Literal",
                            semicolon = "Disable"
                        },
                    },
                },
            }

            lspconfig.marksman.setup {}
            -- lspconfig.markdown_oxide.setup {}

            lspconfig.rust_analyzer.setup {
                settings = {
                    ["rust-analyzer"] = {
                        diagnostics = {
                            styleLints = {
                                enable = true
                            }
                        },
                        inlayHints = {
                            parameterHints = {
                                enable = false
                            },
                            typeHints = {
                                enable = false
                            }
                        }
                    }
                }
            }

            vim.diagnostic.config {
                update_in_insert = true,
                virtual_text = true,
                signs = true,
            }
        end,
        dependencies = {
            {
                "VonHeikemen/lsp-zero.nvim",
                config = function()
                    local lsp_zero = require("lsp-zero")

                    lsp_zero.on_attach(function(_, bufnr)
                        local opts = { buffer = bufnr }

                        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

                        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                        vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)

                        vim.keymap.set("n", "<leader>cr", vim.lsp.buf.references, opts)
                        vim.keymap.set("n", "<leader>cs", vim.lsp.buf.signature_help, opts)
                        vim.keymap.set("n", "<leader>cf", vim.lsp.buf.code_action, opts)
                        vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, opts)

                        vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, opts)

                        -- NOTE: Requires Neovim v0.10.0+
                        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
                    end)

                    lsp_zero.format_on_save {
                        servers = {
                            ["luaformatter"] = { "lua" },
                            ["rust_analyzer"] = { "rust" },
                        },
                        -- format_opts = {
                        --     async = true,
                        -- }
                    }
                end,
            },

            -- Completion
            {
                "hrsh7th/nvim-cmp",
                config = function()
                    local cmp = require("cmp")

                    cmp.setup {
                        view = {
                            docs = {
                                auto_open = true,
                            },
                            entries = {
                                follow_cursor = true,
                            },
                        },
                        window = {
                            completion = cmp.config.window.bordered(),
                            documentation = cmp.config.window.bordered(),
                        },
                        formatting = {
                            fields = { "menu", "abbr", "kind" },
                            format = function (entry, item)
                                local menu_icons = {
                                    nvim_lsp = "$",
                                    luasnip = "λ",
                                }

                                item.menu = menu_icons[entry.source.name]

                                return item
                            end
                        },
                        mapping = cmp.mapping.preset.insert {
                            ["<Esc>"] = map_or_fallback(cmp.visible, cmp.close),
                            ["<Tab>"] = map_or_fallback(cmp.visible, function()
                                cmp.confirm { select = true }
                            end),
                            ["<C-j>"] = cmp.mapping.select_next_item(),
                            ["<C-k>"] = cmp.mapping.select_prev_item(),
                        },
                        snippet = {
                            expand = function(args)
                                require("luasnip").lsp_expand(args.body)
                            end,
                        },
                        sources = cmp.config.sources {
                            { name = "nvim_lsp" },
                            { name = "luasnip" },
                            { name = "path" },
                        },
                        experimental = {
                            ghost_text = false,
                        },
                    }
                end,
                dependencies = {
                    -- Snippets
                    {
                        "L3MON4D3/LuaSnip",
                        build = "make install_jsregexp",
                        config = function()
                            local luasnip = require("luasnip")

                            require("luasnip.loaders.from_vscode").lazy_load()

                            luasnip.setup()

                            vim.keymap.set("i", "<Tab>", luasnip.expand_or_jump)
                        end,
                        dependencies = {
                            { "rafamadriz/friendly-snippets" },
                        }
                    },
                    "hrsh7th/cmp-nvim-lsp",
                    "hrsh7th/cmp-buffer",
                    "hrsh7th/cmp-path",
                }
            },
            "williamboman/mason-lspconfig.nvim",
        },
    },

    {
        "folke/trouble.nvim",
        branch = "dev",
        keys = {
            {
                "<leader>xx",
                ":Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)",
            },
            {
                "<leader>cs",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "Symbols (Trouble)",
            },
            {
                "<leader>cl",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "LSP Definitions / references / ... (Trouble)",
            },
            {
                "<leader>xL",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Location List (Trouble)",
            },
            {
                "<leader>xQ",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Quickfix List (Trouble)",
            },
        },
        opts = {},
    },
    {
        "SmiteshP/nvim-navbuddy",
        keys = {
            {
                "g.",
                ":Navbuddy<CR>",
                desc = "Show LSP symbols navigation"
            },
        },
        dependencies = {
            "SmiteshP/nvim-navic",
            "MunifTanjim/nui.nvim"
        },
        opts = { lsp = { auto_attach = true } }
    },

    -- The numbers, Mason
    { "williamboman/mason.nvim", cmd = "Mason", opts = {} },
    {
        "williamboman/mason-lspconfig.nvim",
        lazy = true,
        dependencies = { "williamboman/mason.nvim" },
        config = function()
            require("mason-lspconfig").setup {
                ensure_installed = {
                    "lua_ls",
                    "rust_analyzer"
                },
            }
        end
    },

    {
        "kdheepak/lazygit.nvim",
        cmd = {
            "LazyGit",
            "LazyGitConfig",
            "LazyGitCurrentFile",
            "LazyGitFilter",
            "LazyGitFilterCurrentFile",
        },
        keys = {
            {
                "<leader>lg",
                "<cmd>LazyGit<cr>",
                desc = "Open lazygit window"
            },
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    }
}
