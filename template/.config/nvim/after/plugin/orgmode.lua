require("orgmode").setup_ts_grammar()
require("orgmode").setup()

-- org-bullets
require("org-bullets").setup {
    concealcursor = true,
    symbols = {
        list = "•",
        headlines = { "◉", "○", "✸", "✿" },
        checkboxes = {
            todo = { " ", "OrgTODO" },
            half = { "-", "OrgTSCheckboxHalfChecked" },
            done = { "", "OrgDone" },
        }
    }
}
