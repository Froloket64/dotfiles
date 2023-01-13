local wez = require "wezterm"
local act = wez.action

-- Main Modifier(-s)
local mod = "ALT"

-- Key binds to switch to specific workspaces
-- MOD + number to activate tab with the number
local tab_keys = {}
for i = 1, 8 do
  table.insert(tab_keys, {
    key = tostring(i),
    mods = mod,
    action = act.ActivateTab(i - 1),
  })
end

return {
    -- Visuals
    color_scheme = "{{ theme }}",
    use_fancy_tab_bar = false,
    font_size = {{ font.size }},
    window_background_opacity = 0.75,
    -- max_fps = 120,
    window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
    },

    -- Key binds
    keys = {
        { -- Spawn new tab
            key = "t",
            mods = mod,
            action = act.SpawnTab "CurrentPaneDomain"
        },

        { -- Close tab
            key = "w",
            mods = mod,
            action = act.CloseCurrentTab { confirm = false }
        },

        -- {
        --     key = "h",
        --     mods = "ALT",
        --     action = act.ActivateTab(
        --         #wez.mux.all_windows() and wez.mux.all_windows()[0].tabs_with_info() or 1
        --     ), -- FIXME: Use current window instead
        -- }

        -- Add other keys
        table.unpack(tab_keys),
    },

    -- Other
    default_prog = { "{{ shell }}" }
}
