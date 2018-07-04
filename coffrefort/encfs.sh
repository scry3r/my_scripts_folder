#!/bin/bash
# License GPL
# by rodofr Live voyager
# Modified by metalux for dynamic change wallpapers
# Display the action selector
if pgrep -f gnome-encfs-manager;then
       kill $(pgrep -f gnome-encfs-manager)
else
	gnome-encfs-manager &
fi


