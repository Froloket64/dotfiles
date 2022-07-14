vim.cmd [[
try
  let g:onedark_config = {
      \ 'style': 'warm',
  \}
  colorscheme gruvbox
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  set background=dark
endtry
]]

-- require("onedark").setup {
--     style = "dark"
-- }
-- require("onedark").load()
