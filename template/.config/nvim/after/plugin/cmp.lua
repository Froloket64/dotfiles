-- local luasnip = require("luasnip")
local cmp = require("cmp")

cmp.setup({
  mapping = {
    ["<C-J>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { "i", "s" }
    ),
    ["<C-K>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { "i", "s" }
    ),
    ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
            cmp.confirm()
        else
            fallback()
        end
    end, { "i", "s" }
    ),
    ["<Enter>"] = nil,
  },
})
