###  Oh My Fish config  ###

## Path to OMF install.
set -q XDG_DATA_HOME
  and set -gx OMF_PATH "$XDG_DATA_HOME/omf"
  or set -gx OMF_PATH "$HOME/.local/share/omf"

## Load OMF
source $OMF_PATH/init.fish

## Env vars
set -gx LC_ALL en_US.utf8
set -gx SHELL /bin/fish

# Manpager
if command -vq bat
    set -l bat_theme "gruvbox-dark"
    set -gx MANPAGER "sh -c 'col -bx | bat --theme $bat_theme -l man -p'"
end

# LSColors
if command -vq vivid
    set -gx LS_COLORS (vivid generate gruvbox-dark-soft) # Needs `vivid`
end

## Other vars/overrides
set fish_greeting # Disable the startup intro message

# Cursor shape
set fish_cursor_default block
set fish_cursor_insert line blink
set fish_cursor_visual block
set fish_cursor_replace underscore

fish_vi_key_bindings # Being eVIl