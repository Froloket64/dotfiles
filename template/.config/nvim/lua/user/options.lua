vim.opt.background = "dark"
vim.cmd("colorscheme gruvbox")

vim.opt.termguicolors = true
vim.o.guifont = "{{ terminalFont.name }}:h{{ terminalFont.size }}"
vim.o.guicursor = "i:block"

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.scrolloff = 8
vim.opt.updatetime = 1000
vim.opt.ignorecase = true
vim.opt.wrap = true
vim.opt.timeoutlen = 1000

-- Always show sign column
vim.wo.signcolumn = "yes"

vim.opt.conceallevel = 2
vim.opt.concealcursor = "nc"

-- Neovide
if vim.g.neovide then
    vim.g.neovide_cursor_animation_length = 0.2
    vim.g.neovide_cursor_trail_size = 0.1
    vim.g.neovide_refresh_rate = {{ monitors[0].rate }}
    vim.g.neovide_refresh_rate_idle = 5
end
