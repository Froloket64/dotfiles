local telescope = require("telescope")

local actions = require("telescope.actions")
local fb_actions = telescope.extensions.file_browser.actions

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
            mappings = {
                ["n"] = {
                    ["a"] = fb_actions.create,
                    ["r"] = fb_actions.rename,
                    ["P"] = fb_actions.move,
                    ["p"] = fb_actions.copy,
                    ["x"] = fb_actions.remove,
                },
            },
        },
    }
}

telescope.load_extension("fzf")
telescope.load_extension("file_browser")
