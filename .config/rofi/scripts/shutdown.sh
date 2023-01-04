#!/usr/bin/env sh
# A simple rofi script with a shutdown, logout, etc. prompt

echo -e "\0prompt\x1fChoose an option"
echo -e "\0theme\x1felement-icon { size: 0.75em; }"

# Option parsing
# if [ x"$@" = x"X" ]; then
#     exit 0
# fi

case x"$@" in
    x"Cancel")
        exit 0
        ;;

    x"Suspend")
        systemctl suspend
        ;;

    x"Log out")
        swaymsg exit
        ;;
esac

# Option display
ICON_PATH=/usr/share/icons/Papirus-Dark/

SUSPEND_ICON="$ICON_PATH/symbolic/actions/system-suspend-symbolic.svg"
LOGOUT_ICON="$ICON_PATH/symbolic/actions/system-log-out-symbolic.svg"
CANCEL_ICON="$ICON_PATH/16x16/actions/cancel.svg"

echo -e "Suspend\0icon\x1f$SUSPEND_ICON"
echo -e "Log out\0icon\x1f$LOGOUT_ICON"
echo -e "Cancel\0icon\x1f$CANCEL_ICON"
