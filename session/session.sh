#!/bin/bash
# License GPL
#Script de rodofr@voyager
if pgrep -f xfce4-panel;then
       xfce4-panel --quit
sleep 8
	xfce4-panel &
fi
exit 0


