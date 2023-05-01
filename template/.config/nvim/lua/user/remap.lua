-- Legend:
-- <leader>...
--   o - Open
--   f - find
--   t - Terminal
--   b - Buffer
--   g - Git
--   r - Replace

vim.g.mapleader = " "

local opts = { silent = true }

-- [[ File management ]]
local function find_file(dir, opts)
    if dir == "" then
        dir = "%:p:h"
    end

    if not opts then
        opts = ""
    end

    return ":Telescope find_files "..opts.." cwd="..dir.."<cr>"
end

local hidden = "hidden=true"

vim.keymap.set("n", "<leader>ff", find_file("", hidden), opts)
vim.keymap.set("n", "<leader>fp", find_file("$HOME/.dotfiles/template/.config/nvim", hidden), opts)
vim.keymap.set("n", "<leader>fa", find_file("$HOME"), opts)

vim.keymap.set("n", "<leader>fr", ":Telescope oldfiles<cr>")

-- Fuzzy file explorer/browser
vim.keymap.set("n", "<leader>fe", ":Telescope file_browser hidden=true cwd=%:p:h<cr>", opts)

-- Project tree
vim.keymap.set("n", "<leader>op", ":NvimTreeToggle<cr>", opts)

-- [[ Terminal ]]
vim.keymap.set("n", "<leader>ts", ":Term<cr>", opts)
vim.keymap.set("n", "<leader>tv", ":VTerm<cr>", opts)

-- [[ Window management ]]
vim.keymap.set("n", "<leader>w", "<C-w>", opts)

vim.keymap.set("n", "<C-h>", "<C-w>h", opts)
vim.keymap.set("n", "<C-j>", "<C-w>j", opts)
vim.keymap.set("n", "<C-k>", "<C-w>k", opts) -- FIXME: Interferes with LSP binding
vim.keymap.set("n", "<C-l>", "<C-w>l", opts)

-- [[ Buffer management ]]
vim.keymap.set("n", "<A-l>", ":bn<cr>", opts)
vim.keymap.set("n", "<A-h>", ":bp<cr>", opts)

vim.keymap.set("n", "<leader>bl", ":bn<cr>", opts)
vim.keymap.set("n", "<leader>bh", ":bp<cr>", opts)

vim.keymap.set("n", "<leader>bk", ":bd<cr>", opts)

vim.keymap.set("n", "<leader>bb", ":Telescope buffers<cr>", opts)

-- [[ Git ]]
vim.keymap.set("n", "<leader>gg", ":Neogit cwd="..vim.fn.expand("%:p:h").."<cr>")

-- [[ Editing ]]
-- Replace all ' with "
vim.keymap.set("n", "<leader>r\'", ":%s/'/\"/g<cr>")
vim.keymap.set("v", "<leader>r\'", ":s/'/\"/g<cr>")

-- Replace all " with '
vim.keymap.set("n", "<leader>r\"", ":%s/\"/'/g<cr>")
vim.keymap.set("v", "<leader>r\"", ":s/\"/'/g<cr>")

-- Increment/decrement number
vim.keymap.set("n", "+", "<C-a>")
vim.keymap.set("n", "-", "<C-x>")

-- [[ Other ]]
-- Clear highlight with ESC
vim.keymap.set("n", "<esc>", ":noh<cr>", opts)
