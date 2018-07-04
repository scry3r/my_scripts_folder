#!/bin/bash
# License GPL
# by rodofr Live Voyager
# Modified by metalux for dynamic change wallpapers
# Display the action selector
#version 2 pour Xfce 4.12 par metalux
current_desktop=$(wmctrl -d | grep '*' | cut -d " " -f1)
if [  ! -z "$1" ];then
   	wmctrl -s2
	xfce4-terminal --maximize --hide-menubar --hide-borders -e "sudo rkhunter --checkall" -H
fi	
exit 0
