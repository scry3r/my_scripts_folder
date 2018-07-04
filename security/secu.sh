#!/bin/sh
# License GPL
# by rodofr@ - Voyager Live - Didier-T@
box=$(yad --title=Security --window-icon="/usr/share/xfce4/voyager/p1.png" --image="/usr/share/xfce4/voyager/Voyager0.png" --image-on-top --separator="" --width=350 --height=200 --list --radiolist --no-headers --column="1" --column="option" --print-column 2 true "Firewall - Pare-feu" false "keepassx - Passport" false "User and Group - Admin" false "ClamTk - Antivirus")

case $box in
        "Firewall - Pare-feu")
	  gufw;;
	"keepassx - Passport")
	  keepassx %f;;
	"User and Group - Admin")
	  users-admin;;
	"ClamTk - Antivirus")
	  clamtk %F;;
    *)
        exit 0
esac
exit 0
