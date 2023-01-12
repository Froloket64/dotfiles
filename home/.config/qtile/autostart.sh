#!/usr/bin/env bash

## Load my machine-specific configs
source ~/.dotfiles-private/qtile/autostart.sh

picom --experimental-backends --daemon
nitrogen --restore
lxappearance &
volumeicon &
nm-applet &
timeshift &
polybar &
dunst &

disable_laptop_mon () {
	xrandr --output eDP --off
	echo "restart()" | qtile shell
	picom --daemon
	pkill polybar
	polybar &
	nitorgen --restore
}

## If connected to an external monitor while on a laptop
if [[ `xrandr --listmonitors` == *eDP* && `xrandr --listmonitors` == *HDMI* ]]; then
	disable_laptop_mon
fi
