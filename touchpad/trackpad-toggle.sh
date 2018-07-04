#!/bin/bash
# License GPL
# by rodofr Live voyager mod by Metalux
# Display the action selector

pid=$(pgrep -f xfce4-mouse-settings)
ps -p $pid && kill $pid || xfce4-mouse-settings


