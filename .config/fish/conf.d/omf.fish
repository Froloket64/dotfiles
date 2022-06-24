###  Oh My Fish config  ###

# Path to Oh My Fish install.
set -q XDG_DATA_HOME
  and set -gx OMF_PATH "$XDG_DATA_HOME/omf"
  or set -gx OMF_PATH "$HOME/.local/share/omf"


# Load Oh My Fish configuration.
source $OMF_PATH/init.fish

# Load aliases
source $HOME/.config/fish/conf.d/aliases.fish

# Env vars
export LC_ALL=en_US.utf8  # Breaks all glyphs
export LS_COLORS=(vivid generate gruvbox-dark-soft)
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# Other vars/overrides
set fish_greeting  # Disbale the startup intro message

# Exec on startup
neofetch  # how d'ya live without it ;)
