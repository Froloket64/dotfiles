-- Legend:
-- <leader>...
--   o - Open
--   f - find
--   t - Terminal

vim.g.mapleader = " "

local opts = { silent = true }

-- Finding files
function find_file(dir)
    local opts = "hidden=true"

    if (dir)
    then
        cmd = ":Telescope find_files "..opts.." cwd="..dir.."<cr>"
    else
        cmd = ":Telescope find_files "..opts.."<cr>"
    end

    return cmd
end

vim.keymap.set("n", "<leader>ff", find_file(), opts) -- FIXME: Use the file's working directory
vim.keymap.set("n", "<leader>fp", find_file("$XDG_CONFIG_HOME/nvim"), opts)
vim.keymap.set("n", "<leader>fa", find_file("$HOME"), opts)

-- Project tree
vim.keymap.set("n", "<leader>op", ":NvimTreeToggle<cr>", opts)

-- terminal
-- vim.keymap.set("n", "<leader>ot", ":vsplit<cr> :terminal<cr>")
vim.keymap.set("n", "<leader>ts", ":Term<cr>", opts)
vim.keymap.set("n", "<leader>tv", ":VTerm<cr>", opts)

-- Window management
vim.keymap.set("n", "<leader>w", "<C-w>", opts)

-- Buffer management
-- vim.keymap.set("n", "<leader>b]", ":BufferNext<cr>", opts)
-- vim.keymap.set("n", "<leader>bl", ":BufferNext<cr>", opts)
vim.keymap.set("n", "<C-l>", ":BufferNext<cr>", opts)

-- vim.keymap.set("n", "<leader>b[", ":BufferPrevious<cr>", opts)
-- vim.keymap.set("n", "<leader>bh", ":BufferPrevious<cr>", opts)
vim.keymap.set("n", "<C-h>", ":BufferPrevious<cr>", opts)

vim.keymap.set("n", "<leader>bk", ":BufferClose<cr>", opts)

-- Clear highlight with ESC
vim.keymap.set("n", "<esc>", ":noh<cr>", opts)

-- Increment/decrement number
vim.keymap.set("n", "+", "<C-a>")
vim.keymap.set("n", "-", "<C-x>")
