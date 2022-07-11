"" Aequatio script files

syn keyword eqKeyword expr rule apply insert print save done exit quit
syn keyword eqImport  import as
syn keyword eqBuiltin all
syn keyword eqOption  reverse

syn match eqOperator "[+\-*/]"
syn match eqComment  "#.*"
syn match eqRule     "[A-Z]\w*"
syn match eqNumber   "\d"

hi def link eqKeyword  Keyword
hi def link eqBuiltin  Type
hi def link eqOption   Special
hi def link eqOperator Delimiter
hi def link eqComment  Comment
hi def link eqImport   Include
hi def link eqRule     Identifier
hi def link eqNumber   Number
