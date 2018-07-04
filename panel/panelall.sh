#!/bin/bash
# License GPL
# by rodofr Live Voyager
#contribution par metalux
# Display the action selector
if [[ $(xfconf-query -c xfce4-panel -p /panels/panel-0/autohide) == true ]] && [[ $(xfconf-query -c xfce4-panel -p /panels/panel-1/autohide) == true ]] && [[ $(xfconf-query -c xfce4-panel -p /panels/panel-2/autohide) == true ]] && [[ ! -e .config_panel0 ]];then
	xfconf-query -c xfce4-panel -p /panels/panel-0/autohide -n -t bool -s true
	xfconf-query -c xfce4-panel -p /panels/panel-1/autohide -n -t bool -s true
	xfconf-query -c xfce4-panel -p /panels/panel-2/autohide -n -t bool -s true
	
fi
if [[ $(xfconf-query -c xfce4-panel -p /panels/panel-0/autohide) == false ]] || [[ $(xfconf-query -c xfce4-panel -p /panels/panel-1/autohide) == false ]] || [[ $(xfconf-query -c xfce4-panel -p /panels/panel-2/autohide) == false ]];then
	xfconf-query -c xfce4-panel -p /panels/panel-0/autohide > .config_panel0
	xfconf-query -c xfce4-panel -p /panels/panel-1/autohide > .config_panel1
	xfconf-query -c xfce4-panel -p /panels/panel-2/autohide > .config_panel2
fi
if [[ $(xfconf-query -c xfce4-panel -p /panels/panel-0/autohide) == true ]] && [[ $(xfconf-query -c xfce4-panel -p /panels/panel-1/autohide) == true ]] && [[ $(xfconf-query -c xfce4-panel -p /panels/panel-2/autohide) == true ]] ;then
	xfconf-query -c xfce4-panel -p /panels/panel-0/autohide -n -t bool -s $(<.config_panel0)
	xfconf-query -c xfce4-panel -p /panels/panel-1/autohide -n -t bool -s $(<.config_panel1)
	xfconf-query -c xfce4-panel -p /panels/panel-2/autohide -n -t bool -s $(<.config_panel2)
else
	xfconf-query -c xfce4-panel -p /panels/panel-0/autohide -n -t bool -s true
	xfconf-query -c xfce4-panel -p /panels/panel-1/autohide -n -t bool -s true
	xfconf-query -c xfce4-panel -p /panels/panel-2/autohide -n -t bool -s true
fi
exit 0