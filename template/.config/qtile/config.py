# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
# Copyright (c) 20XX Froloket64
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import os
import subprocess
from libqtile import qtile
from libqtile.config import Click, Drag, Group, Key, Match, Screen, ScratchPad, DropDown
from libqtile import layout, bar, widget, hook #, guess_terminal
from libqtile.command import lazy
from typing import List  # noqa: F401


mod = "mod4"
terminal = "alacritty"

shell = "fish"
shell_cmds = "-C neofetch"

# terminal = guess_terminal() # Needs import ^

# Key Binds
keys = [
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),

    # Moving windows
    # (WARNING: Moving out of range in Columns layout will create new column)
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(),
        desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(),
        desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(),
        desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),

    # Resize windows
    Key([mod, "control"], "h", lazy.layout.grow_left(),
        desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(),
        desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(),
        desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key([mod, "shift"], "Return", lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack"),

    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod, "shift"], "Tab", lazy.prev_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),

    # Key([mod], "r", lazy.spawncmd(),
    #     desc="Spawn a command using a prompt widget"),

    # Application start binds
    Key([mod], "Return", lazy.spawn(f"{terminal} -e {shell} {shell_cmds}"), desc="Run terminal (defined by var)"),
    Key([mod], "d", lazy.spawn("rofi -show drun"), desc="Run app launcher (rofi here)"),
    Key([mod, "control"], "h", lazy.spawn(f"{terminal} -e htop"), desc="Run htop in the chosen terminal"),
    Key([mod], "s", lazy.spawn(["sh", "-c", "scrot -F ~/Pictures/screen.png"]), desc="Take a quick screenshot"),

    # Toggle layouts
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen"),
    Key([mod, "shift"], "Return", lazy.window.toggle_floating(), desc="Toggle floating"),

    # System/WM actions
    Key([mod, "shift"], "r", lazy.restart(), desc="Restart Qtile"),
    Key([mod, "shift"], "q", lazy.shutdown(), desc="Exit Qtile / Log out")
]


### Groups ###
## Names of groups (workspaces)
## Format:
## ({<Name variants for> 'icon', 'full', 'minimal'}, (<Apps to open there by default>))
groups_raw = [
    ({'icon': 'λ', 'full': 'λ Terminal', 'minimal': 'TRM'},  ## Terminal
        # ['Alacritty' if terminal == 'alacritty' else terminal]),  ## Alacritty's name should start with capital letter (special case)
        []),

    ({'icon': '', 'full': ' Code', 'minimal': 'COD'},  ## Code
        ['code', 'code-oss', 'codium', 'Emacs']),

    ({'icon': '', 'full': ' Web', 'minimal': 'WEB'},  ## Web/Browser
        ['firefox', 'LibreWolf']),

    ({'icon': '', 'full': ' Games', 'minimal': 'GAM'},  ## Games
        ['Steam', 'fceux', 'gzdoom']),

    ({'icon': '', 'full': ' Work', 'minimal': 'WOR'}, ## Work (or whatever you call it)
        ['qbittorrent', 'Triangula', 'htop', 'libreoffice']),

    ({'icon': '',  'full': ' Music', 'minimal': 'MUS'},  ## Music
        ['deadbeef', 'mpv']),
]

mode = 'minimal'

## Select only suitable name variants
group_names = [group[0][mode] for group in groups_raw]

# Some Symbols: '  λ    '

## Generate a qtile-readable thing out of this 'nonsense' ;)
groups = []
for index, name in enumerate(group_names):
    groups.append( Group( name, matches=[Match(groups_raw[index][1])] ) )


for num, group in enumerate(groups, 1):
    name = group.name

    keys.extend([
        # Switch to group
        Key(
            [mod], str(num), lazy.group[name].toscreen(),
            desc=f"Switch to group {name}"
            ),

        # Move focused window to group
        Key(
            [mod, "shift"], str(num), lazy.window.togroup(name, switch_group=False),
            desc=f"Switch to & move focused window to group {name}"
            )
    ])


## ScratchPad Group
# groups.append( ScratchPad("scratchpad", [
        # ## DropDown terminal
        # DropDown("term", terminal,
            # height=0.25,
            # on_focus_lost_hide=False,
            # opacity=0.9,
            # width=1,
            # x=0,
            # y=0
        # )
    # ])
# )

# keys.append(Key([mod], "t", lazy.group["scratchpad"].dropdown_toggle("term")))  ## Seems kinda buggy though


## Layouts
layout_defaults = {
    "border_width": 1,
    "margin": 5,
    "border_focus": "689d6a",
    "border_normal": "928374"
}

layout_tile = {
    "ratio": 0.75,
    "add_after_last": True
}

layout_columns = {
    "border_on_single": False
}

layout_treetab = {
    "bg_color": "272822",
    "section_fg": "606060",

    "active_bg": "78e632",
    "active_fg": "606060",
    "inactive_fg": "78e632",

    "font": "JetBrainsMono Nerd Font",
    "fontsize": 16,
    "section_font": "JetBrainsMono Nerd Font",
    "section_fontsize": 14
}

floating_layout = layout.Floating(float_rules=[
    ## Run the utility of `xprop` to see the wm class and name of an X client.
    *layout.Floating.default_float_rules,
    Match(wm_class='confirmreset'),  # gitk
    Match(wm_class='makebranch'),  # gitk
    Match(wm_class='maketag'),  # gitk
    Match(wm_class='ssh-askpass'),  # ssh-askpass
    Match(title='branchdialog'),  # gitk
    Match(title='pinentry'),  # GPG key password entry
    ],
    border_focus=layout_defaults["border_focus"],
    border_normal=layout_defaults["border_normal"],
)

layouts = [
    layout.Tile(**layout_defaults, **layout_tile),
    layout.Columns(**layout_defaults, **layout_columns),
    # layout.TreeTab(**layout_treetab),
]

widget_defaults = {
    "font": 'Ubuntu Mono',
    "fontsize": 14,
    "padding": 3,
}

extension_defaults = widget_defaults.copy()
widgetSep_defaults = {
        'linewidth': 0,
        'padding': 10
}


screens = [Screen()]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
auto_fullscreen = True
focus_on_window_activation = "smart"

# Loading apps on startup (See `autostart.sh`) 
@hook.subscribe.startup_once
def start_once():
    home = os.path.expanduser('~')
    subprocess.call([f'{home}/.config/qtile/autostart.sh'])

# XXX: Gasp! We [Devs] are lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
