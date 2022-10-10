###  Oh My Fish config  ###

## Path to OMF install.
set -q XDG_DATA_HOME
  and set -gx OMF_PATH "$XDG_DATA_HOME/omf"
  or set -gx OMF_PATH "$HOME/.local/share/omf"

## Load OMF
source $OMF_PATH/init.fish

## Env vars
export LC_ALL=en_US.utf8

# Manpager
if command -vq bat
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
end

# LSColors
if command -vq vivid
    export LS_COLORS=(vivid generate gruvbox-dark-soft) # Needs `vivid`
end

## Other vars/overrides
set fish_greeting # Disbale the startup intro message

fish_vi_key_bindings # eVIl, am i right?

## Exec on startup
neofetch # how d'ya live without it ;)
