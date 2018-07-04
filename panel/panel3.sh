#!/bin/bash
# License GPL
# by rodofr Live Voyager
# Display the action selector
xfconf-query -c xfce4-panel -p /panels/panel-3/autohide-behavior entier -s 1 &
xfconf-query -c xfce4-panel -p /panels/panel-3/autohide-behavior entier -s 2 &

exit 0