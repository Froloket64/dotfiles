-- Legend:
-- <leader>...
--   o - Open
--   f - find
--   t - Terminal
--   b - Buffer

vim.g.mapleader = " "

local opts = { silent = true }

-- Finding files
local function find_file(dir)
    local opts = "hidden=true"

    if (not dir) then
        dir = "%:p:h"
    end

    return ":Telescope find_files "..opts.." cwd="..dir.."<cr>"
end

vim.keymap.set("n", "<leader>ff", find_file(), opts)
vim.keymap.set("n", "<leader>fp", find_file("$XDG_CONFIG_HOME/nvim"), opts)
vim.keymap.set("n", "<leader>fa", find_file("$HOME"), opts)

-- Fuzzy file explorer/browser
vim.keymap.set("n", "<leader>fe", ":Telescope file_browser hidden=true<cr>", opts)

-- Project tree
vim.keymap.set("n", "<leader>op", ":NvimTreeToggle<cr>", opts)

-- Terminal
vim.keymap.set("n", "<leader>ts", ":Term<cr>", opts)
vim.keymap.set("n", "<leader>tv", ":VTerm<cr>", opts)

-- Window management
vim.keymap.set("n", "<leader>w", "<C-w>", opts)

-- Buffer management
vim.keymap.set("n", "<C-l>", ":BufferNext<cr>", opts)

vim.keymap.set("n", "<C-h>", ":BufferPrevious<cr>", opts)

vim.keymap.set("n", "<leader>bk", ":BufferClose<cr>", opts)

-- Clear highlight with ESC
vim.keymap.set("n", "<esc>", ":noh<cr>", opts)

-- Increment/decrement number
vim.keymap.set("n", "+", "<C-a>")
vim.keymap.set("n", "-", "<C-x>")
