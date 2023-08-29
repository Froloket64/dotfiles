local hop = require("hop")
local directions = require("hop.hint").HintDirection

hop.setup {
    keys = "etovxqpdygfblzhckisuran",
}

vim.keymap.set("n", "f", function()
    hop.hint_char1 {
        direction = directions.AFTER_CURSOR,
        current_line_only = true,
    }
end)
vim.keymap.set("n", "F", function()
    hop.hint_char1 {
        direction = directions.BEFORE_CURSOR,
        current_line_only = true,
    }
end)
vim.keymap.set("n", "t", function()
    hop.hint_char1 {
        direction = directions.AFTER_CURSOR,
        current_line_only = true,
        hint_offset = -1,
    }
end)
vim.keymap.set("n", "T", function()
    hop.hint_char1 {
        direction = directions.BEFORE_CURSOR,
        current_line_only = true,
        hint_offset = 1,
    }
end)
