###  Oh My Fish config  ###


## Path to Oh My Fish install.
set -q XDG_DATA_HOME
  and set -gx OMF_PATH "$XDG_DATA_HOME/omf"
  or set -gx OMF_PATH "$HOME/.local/share/omf"

## Load Oh My Fish configuration.
source $OMF_PATH/init.fish

## Env vars
export LC_ALL=en_US.utf8  ## Breaks all glyphs
export LS_COLORS=(vivid generate molokai)
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

## Aliases
alias ls="lsd"
alias ll="lsd -l"
alias commit="git commit -m"
alias push="git push -u origin"
alias battery="upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -E \"state:|time\ to\ full:|percentage:\""
alias timer="$HOME/Git/countdown/countdown_linux_amd64"
alias alarm="timeout 5s cvlc $HOME/Downloads/Alarm_sound.mp3"

## Exec on startup
neofetch  ## how d'ya live without it ;)
