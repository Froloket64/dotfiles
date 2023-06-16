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
vim.keymap.set("n", "<leader>ts", ":ToggleTerm direction=horizontal<cr>", opts)
vim.keymap.set("n", "<leader>tv", ":ToggleTerm direction=vertical<cr>", opts)

-- NOTE: Breaks certain commands (e.g. lazygit)
-- vim.keymap.set("t", "jk", "<C-\\><C-n>", opts)

vim.keymap.set("t", "<C-h>", "<Cmd>wincmd h<cr>", opts)
vim.keymap.set("t", "<C-j>", "<Cmd>wincmd j<cr>", opts)
vim.keymap.set("t", "<C-k>", "<Cmd>wincmd k<cr>", opts)
vim.keymap.set("t", "<C-l>", "<Cmd>wincmd l<cr>", opts)

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

-- [[ Editing ]]
-- Replace all ' with "
vim.keymap.set("n", "<leader>r\'", ":%s/'/\"/g<cr>", opts)
vim.keymap.set("v", "<leader>r\'", ":s/'/\"/g<cr>", opts)

-- Replace all " with '
vim.keymap.set("n", "<leader>r\"", ":%s/\"/'/g<cr>", opts)
vim.keymap.set("v", "<leader>r\"", ":s/\"/'/g<cr>", opts)

-- Increment/decrement number
vim.keymap.set("n", "+", "<C-a>")
vim.keymap.set("n", "-", "<C-x>")

-- Replace all occurences
function ReplaceAll()
    local word = vim.fn.expand("<cword>")
    local replacement = vim.fn.input("Replace with: ")

    vim.cmd(":%s/"..word.."/"..replacement.."/g")
    -- vim.cmd("normal <CTRL-O>") -- FIXME Jump back
end

vim.keymap.set("n", "<leader>ro", ReplaceAll)

-- Navbuddy
vim.keymap.set("n", "g.", ":Navbuddy<cr>", opts)

-- [[ Other ]]
-- Clear highlight with ESC
vim.keymap.set("n", "<esc>", ":noh<cr>", opts)

vim.keymap.set("n", "<leader>ce", ":Trouble<cr>", opts)
