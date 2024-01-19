require("todo-comments").setup {
    sings = false,
    keywords = {
        TODO  = { icon = "", color = "info" },
        HACK  = { icon = "", color = "warning" },
        FIX   = { icon = "", color = "error" },
        OPTIM = { icon = "", color = "hint" },
        NOTE  = { icon = "", color = "hint" },
    },
    highlight = {
        comments_only = true,
    },
}
