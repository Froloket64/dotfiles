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
import re
import socket
import subprocess
from libqtile import qtile
from libqtile.config import Click, Drag, Group, KeyChord, Key, Match, Screen
from libqtile.command import lazy
from libqtile import layout, bar, widget, hook#, guess_terminal
from libqtile.command import lazy
from typing import List  # noqa: F401


mod = "mod4"
terminal = "alacritty" 
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
    Key([mod], "Return", lazy.spawn(terminal), desc="Run terminal (defined by var)"),
    Key([mod], "d", lazy.spawn("rofi -show drun"), desc="Run app launcher (rofi here)"),
    Key([mod, "control"], "h", lazy.spawn(f"{terminal} -e htop"), desc="Run htop in the chosen terminal"),

    # Toggle layouts
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen"),
    Key([mod, "shift"], "Return", lazy.window.toggle_floating(), desc="Toggle floating"),

    # System/WM actions
    Key([mod, "shift"], "r", lazy.restart(), desc="Restart Qtile"),
    Key([mod, "shift"], "q", lazy.shutdown(), desc="Exit Qtile / Log out")
]


### Groups ###
## Names of (window) groups
terminal_group = 'λ Terminal'
code_group = ' Code'
web_group = ' Web'
games_group = ' Games'
work_group = ' Work'

groupNames = [
        terminal_group,
        code_group,
        web_group,
        games_group,
        work_group
]

# Some Symbols: '  λ    '

## Making an easier-usable list of all groups
groups = []
for name in groupNames:
    if name == terminal_group:  ## Put following to `terminal` group:
        if terminal == 'alacritty':
            groups.append( Group( name, matches=[Match(wm_class=['Alacritty'])] ) )  ## <Currently set terminal>
        else:
            groups.append( Group( name, matches=[Match(wm_class=[terminal])] ) )  ## <Currently set terminal>
    elif name == code_group:  ## Put following to `code` group:
        groups.append( Group( name, matches=[Match(wm_class=['code', 'code-oss', 'Emacs'])] ) ) ## VSCode
    elif name == web_group:  ## Put following to `web` group:
        groups.append( Group( name, matches=[Match(wm_class=['firefox'])] ) )  ## Firefox
    elif name == games_group:  ## Put following to `games` group:
        groups.append( Group( name, matches=[Match(wm_class=['Steam', 'fceux', 'gzdoom'])] ) )  ## Steam (Runtime), FCEUX
    elif name == work_group:
        groups.append( Group( name, matches=[Match(wm_class=['qbittorrent', 'Triangula', 'htop', 'libreoffice'])] ) ) ## qBitTorrent, Triangula, htop, LibreOffice (all apps)
    else:
        groups.append( Group(name) )


for num, group in enumerate(groups, 1):
    name = group.name

    keys.extend([
        # Switch to group
        Key(
            [mod], str(num), lazy.group[name].toscreen(),
            desc=f"Switch to group {name}"
            ),

        # Move focused window & switch to group
        Key(
            [mod, "shift"], str(num), lazy.window.togroup(name, switch_group=True),
            desc=f"Switch to & move focused window to group {name}"
            )

        # Or, use below if you prefer not to switch to that group.
        # # mod1 + shift + letter of group = move focused window to group
        # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
        #     desc="move focused window to group {}".format(i.name)),
    ])


## Layouts
layout_defaults = {
        "border_width": 2,
        "margin": 8,
        "border_focus": "1dcf91",
        "border_normal": "1D2330"
}

layouts = [
    layout.Tile(**layout_defaults),
    layout.Max(),
    layout.Columns(**layout_defaults),
#    layout.Stack(num_stacks=2),
#    layout.Bsp(),
#    layout.Matrix(),
#    layout.MonadTall(),
#    layout.MonadWide(),
#    layout.RatioTile(),
    layout.TreeTab(),
#    layout.VerticalTile(),
#    layout.Zoomy(),
]

widget_defaults = dict(
    font='Ubuntu Mono',
    fontsize=14,
    padding=3,
)
extension_defaults = widget_defaults.copy()
widgetSep_defaults = {
        'linewidth': 0,
        'padding': 10
}

screens = [
    Screen(
        bottom=bar.Bar(
            [
                widget.CurrentLayout(),
                widget.Sep(**widgetSep_defaults),
                widget.GroupBox(),
                widget.Sep(**widgetSep_defaults),
#                widget.Prompt(),
                widget.WindowName(),
#                widget.Chord(
#                    chords_colors={
#                        'launch': ("#ff0000", "#ffffff"),
#                    },
#                    name_transform=lambda name: name.upper(),
#                ),
                widget.Systray(),
                widget.Sep(**widgetSep_defaults),
                widget.Clock(format='%I:%M | %a, %d.%m.%Y'),
                widget.Sep(**widgetSep_defaults),
                widget.QuickExit(),
            ],
            20,
        ),
    ),
]

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
main = None  # ! WARNING: this is deprecated and will be removed soon
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    *layout.Floating.default_float_rules,
    Match(wm_class='confirmreset'),  # gitk
    Match(wm_class='makebranch'),  # gitk
    Match(wm_class='maketag'),  # gitk
    Match(wm_class='ssh-askpass'),  # ssh-askpass
    Match(title='branchdialog'),  # gitk
    Match(title='pinentry'),  # GPG key password entry
])
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
