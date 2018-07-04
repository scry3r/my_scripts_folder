#!/bin/bash
# Modified by Metalux and Rodofr@Voyager Live
status=$( LC_ALL=C nmcli -t -f WIFI radio)
if [ $status = "enabled" ] ; then
    notify-send -i network-wireless-disconnected "Wireless" "Wireless disabled"
    nmcli radio wifi off
else
    notify-send -i network-wireless-none "Wireless" "Wireless enabled"
    nmcli radio wifi on
fi
exit 0