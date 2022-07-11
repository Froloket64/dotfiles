" Thoughts
" mb use C comment?

" syn keyword vCondition if else
syn keyword vKeyword fn struct type interface
syn keyword vKeyword if else
syn keyword vKeyword for in
syn keyword vKeyword match
syn keyword vKeyword mut pub

syn keyword vImport import

syn keyword vBuiltin print println print_backtrace
syn keyword vBuiltin eprint eprintln
syn keyword vBuiltin exit panic

syn keyword vBuiltinType bool string rune voidptr any T
syn keyword vBuiltinType i8 i16 int i64 i128
syn keyword vBuiltinType u8 u16 u32 u64 u128
syn keyword vBuiltinType f32 f64
syn keyword vBuiltinType isize usize

syn match vStruct "\w\+\(<.*>\)\? *{" contains=vPunct
" syn sync match vStruct "^struct \+\w\+ *"

syn match vNumber "\d\+"

" mb make vEquals hard-coded? (saves time)
syn keyword vOperator + - * /
syn match vEquals "[:+\-*\/]\?=\+"

" syn match vFunction "\w\+(.\{-})" contains=ALL
syn match vFunction "\w\+(" contains=vPunct

syn match vComment "//.*"
syn match vComment "\/\*\(.\|\n\)\{-}\*\/"

" TODO
" syn match vEscape "" contained
syn match vString "\".\{-}\"" contains=vStringInterSimple,vStringInterExt,vEscape,vDirectory
syn match vStringInterSimple "\$\w\+\(\.\w\+\)*" contained
syn match vStringInterExt    "\${.*}" contains=ALL
syn match vDirectory "\w*\/\(\w*\/*\)*" contained

" Seems like some of the chars are not allowed as keywords so here you go
syn match vPunct "[\[\](){};:,.<>]"

" hi def link
hi def link vFunction                  Function
hi def link vKeyword                   Keyword
hi def link vImport                    Include
hi def link vComment                   Comment
hi def link vBuiltin                   Special
hi def link vBuiltinType               Type
hi def link vOperator                  Operator
hi def link vEquals                    Operator
hi def link vString                    String
hi def link vStringInterSimple         Bold
hi def link vStringInterExt            Bold
hi def link vPunct                     Delimiter
hi def link vNumber                    Number
hi def link vDirectory                 Directory
hi def link vStruct                    Structure
