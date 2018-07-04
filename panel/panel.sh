#!/bin/bash
# License GPL
# by rodofr Live Voyager
# Display the action selector
xfconf-query -c xfce4-panel -p /panels/panel-1/autohide -n -t bool -s false &
# xfconf-query -c xfce4-panel -p /panels/panel-1/disable-struts -n -t bool -s true &
xfconf-query -c xfce4-panel -p /panels/panel-1/autohide -n -t bool -s true &

exit 0
