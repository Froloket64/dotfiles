## Aliases
# --Commands-- ###
alias ls="lsd"  # ;)
alias ll="lsd -l"
alias cl="clear; ll"
alias clt="clear; ls --tree"
alias myip="curl zx2c4.com/ip"
alias htb="sudo openvpn ~/Downloads/htb.ovpn"
alias ubuntu="docker start -ia my-ubuntu"
alias logout="pkill -KILL -u $USER"

# --Scripts-- ###
alias battery="upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -E \"state:|time\ to\ full:|percentage:\""
alias alarm="cvlc -L $HOME/Downloads/Alarm_sound.mp3"
alias dunst-alarm="dunstify --icon /usr/share/icons/Papirus/16x16/actions/dialog-error.svg 'Time is UP!'"
alias etcher="$HOME/AppImages/balenaEtcher.AppImage"
