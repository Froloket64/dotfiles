" hi /\[.*\]/ ctermfg=Green guifg=Green
syn keyword opStack  / \

syn match opComment "\[.*\]"

hi def link opComment Comment
hi def link opStack   Comment
