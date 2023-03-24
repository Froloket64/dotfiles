local telescope = require("telescope")
local actions = require("telescope.actions")

telescope.setup {
    defaults = {
        mappings = {
            i = {
                -- Movement
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
            },
        },
    },
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
        },
        file_browser = {
            theme = "ivy",
            hijack_netrw = true,
        }
    },
}

telescope.load_extension("fzf")
telescope.load_extension("file_browser")
