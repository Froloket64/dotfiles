#!/usr/bin/bash

## DISCLAIMER: The lower "if" line disables
## an input device with ID 11 (in my case,
## the touchpad that breaks Qtile for some reason ;) ).
##
## I set the envvar to make it work, so you won't get
## influenced by this, however, be aware that
## IDs of devices are different on different PCs,
## so you can easily disable smth like your mouse
## using this line, which doesn't seem like fun, does it?
##
## PS: See list of devices using `xinput` command
## with no args/options

if [ $DISABLE_TOUCHPAD = true ]; then
	xinput --disable 11 &
fi
lxappearance &
picom --experimental-backends &
nitrogen --restore &
volumeicon &
nm-applet &
timeshift &
# lxsession &
