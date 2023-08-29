local cmp = require("cmp")

cmp.setup {
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    sources = cmp.config.sources {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "ultisnips" },
        { name = "path" },
    },
    formatting = {
        fields = { "menu", "abbr", "kind" },
        format = function(entry, item)
            local menu_icons = {
                nvim_lsp = "$",
                luasnip = "λ",
            }

            item.menu = menu_icons[entry.source.name]

            return item
        end
    },
    mapping = {
        -- Select next completion
        ["<C-j>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            else
                fallback()
            end
        end, { "i", "s" }
        ),
        -- Select previous completion
        ["<C-k>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            else
                fallback()
            end
        end, { "i", "s" }
        ),
        -- Scroll text in the documentation window up
        ["<C-n>"] = cmp.mapping(function(fallback)
            if cmp.visible then
                cmp.mapping.scroll_docs(4)
            else
                fallback()
            end
        end),
        -- Scroll text in the documentation window down
        ["<C-p>"] = cmp.mapping(function(fallback)
            if cmp.visible then
                cmp.mapping.scroll_docs(-4)
            else
                fallback()
            end
        end),
        -- Confirm if visible, otherwise fall back
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.confirm()
            else
                fallback()
            end
        end, { "i", "s" }
        ),
        -- Override <Enter>
        ["<CR>"] = cmp.mapping(function(fallback)
            fallback()
        end),
        -- Abort the current completion
        ["<Esc>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.abort()
            else
                fallback()
            end
        end),
    },
}
