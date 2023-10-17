-- ~/.config/nvim/after/ftplugin/haskell.lua
local haskell_tools = require("haskell-tools")
local bufnr = vim.api.nvim_get_current_buf()
local opts = { noremap = true, silent = true, buffer = bufnr, }

-- haskell-language-server relies heavily on codeLenses,
-- so auto-refresh (see advanced configuration) is enabled by default
vim.keymap.set("n", "<space>ca", vim.lsp.codelens.run, opts)

-- Hoogle search for the type signature of the definition under the cursor
vim.keymap.set("n", "<space>hs", haskell_tools.hoogle.hoogle_signature, opts)

-- Evaluate all code snippets
vim.keymap.set("n", "<space>ea", haskell_tools.lsp.buf_eval_all, opts)

-- Toggle a GHCi repl for the current package
vim.keymap.set("n", "<leader>rr", haskell_tools.repl.toggle, opts)

-- Toggle a GHCi repl for the current buffer
vim.keymap.set("n", "<leader>rf", function()
    haskell_tools.repl.toggle(vim.api.nvim_buf_get_name(0))
end, opts)

vim.keymap.set("n", "<leader>rq", haskell_tools.repl.quit, opts)
