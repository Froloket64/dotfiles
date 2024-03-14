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
    set -gx BAT_THEME "{{ themes.bat }}"
    set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
end

# LSColors
if command -vq vivid
    set -gx LS_COLORS (vivid generate {{ themes.vivid }})
end

## Other vars/overrides
set fish_greeting # Disable the startup intro message
set -gx EDITOR {{ "emacsclient -nw" if general.editor == "emacs" else general.editor }}
set -gx COLORTERM truecolor
set -gx MAKEFLAFS "-j$(nproc)"

# Cursor shape
set fish_cursor_default block
set fish_cursor_insert block
set fish_cursor_visual block
set fish_cursor_replace underscore

fish_vi_key_bindings # Being eVIl

{%- if features.starship %}

# Starship prompt
starship init fish | source

{%- endif %}
