local Terminal = require('toggleterm.terminal').Terminal

local lazygit = Terminal:new {
    cmd = "lazygit",
    hidden = true,
    direction = "float",
    dir = "%:p:h"
}

local function toggle_term(term)
    return function() term:toggle() end
end

local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>gg", toggle_term(lazygit), opts)
