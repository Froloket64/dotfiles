-- NOTE: I hate Lua
-- Copies key-value pairs from `substitutes` table to `source` table
local function combine_tables(source, substitutes)
    for k, v in pairs(substitutes) do source[k] = v end
end

-- Returns the highlight group `group_name` as a dict
local function get_hl_group(group_name)
    return vim.api.nvim_get_hl(0, { name = group_name })
end

-- Returns the highlight group `group_name`'s "link" group as a dict
local function get_hl_link(group_name)
    return get_hl_group(get_hl_group(group_name)["link"])
end

-- Sets the highlight group `group_name`'s definition to `hl_map` (dict),
-- clearing all other attributes
local function set_hl(group_name, hl_map)
    vim.api.nvim_set_hl(0, group_name, hl_map)
end

-- Overrides highlight attributes of the group `group_name`
-- with key-value pairs from `hl_map`
local function override_hl_attrs(group_name, hl_map)
    local group = get_hl_group(group_name)

    -- Get the link's definition if exists
    if group["link"] ~= nil  then
        group = get_hl_link(group_name)
    end

    combine_tables(group, hl_map)

    set_hl(group_name, group)
end

-- Clears the group `group_name` of attrs from `attrs`
local function clear_hl_attrs(group_name, attrs)
    local remove_table = {}

    for _, k in ipairs(attrs) do
        if k == "link" then
            remove_table[k] = ""
        else
            remove_table[k] = "NONE"
        end
    end

    override_hl_attrs(group_name, remove_table)
end

-- GitSigns
local remove = { "bg", "link" }

set_hl("SignColumn", get_hl_group("LineNr"))

clear_hl_attrs("GitSignsAdd",    remove)
clear_hl_attrs("GitSignsChange", remove)
clear_hl_attrs("GitSignsDelete", remove)
-- Do the same for ..Nr and ..Ln to remove line number and line bg's respectively

set_hl("GitSignsUntracked", { fg = get_hl_group("DiagnosticSignWarn")["fg"]})

-- Vim Diagnostics
clear_hl_attrs("DiagnosticSignError", remove)
clear_hl_attrs("DiagnosticSignWarn",  remove)
clear_hl_attrs("DiagnosticSignInfo",  remove)
clear_hl_attrs("DiagnosticSignHint",  remove)

-- Illuminate
set_hl("IlluminatedWordText", { bg = "#444444", bold = true })

-- Org
clear_hl_attrs("Conceal", { "bg" })
clear_hl_attrs("Folded", { "bg" })

override_hl_attrs("OrgTSCheckboxHalfChecked", { fg = "#83a598", bold = true })
override_hl_attrs("OrgDone", { fg = "#b8bb26", bold = true })
set_hl("OrgBulletsDash", { fg = "#b8bb26", bold = false })
