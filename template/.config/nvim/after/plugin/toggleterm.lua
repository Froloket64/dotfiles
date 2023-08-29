require("toggleterm").setup {
    on_open = function(_) vim.cmd("ToggleNeoColumn") end,
    on_close = function(_) vim.cmd("ToggleNeoColumn") end,
}

local Terminal = require('toggleterm.terminal').Terminal

local lazygit = Terminal:new {
    cmd = "lazygit",
    hidden = true,
    direction = "float",
    dir = "%:p:h"
}

local bacon = Terminal:new {
    cmd = "bacon",
    hidden = true,
    direction = "horizontal",
    size = 50,
    dir = "%:p:h"
}

local function toggle_term(term)
    return function() term:toggle() end
end

local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>gg", toggle_term(lazygit), opts)
vim.keymap.set("n", "<leader>tb", toggle_term(bacon), opts)
