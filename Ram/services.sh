#! /bin/bash
# License GPL
# by rodofr@ - Voyager Live
box=$(yad --title=Services --window-icon="/usr/share/xfce4/voyager/p1.png" --image="/usr/share/xfce4/voyager/Voyager0.png" --image-on-top --separator="" --width=500 --height=180 --list --radiolist --no-headers --directory --column="1" --column="option" --print-column 2 true "Services Minimum - No Bluetooth Print-applet Update-notifier" false "Services Minimum Extrem - Minimum + No Xscreensaver Conky" false "Services Standard - Ok Bluetooth Print-applet Update-notifier Xscreensaver Conky")

case $box in
        "Services Minimum - No Bluetooth Print-applet Update-notifier")
	  sh -c ~/.scripts/Ram/ram.sh;;
	"Services Minimum Extrem - Minimum + No Xscreensaver Conky")
	  sh -c ~/.scripts/Ram/ram1.sh;;
	"Services Standard - Ok Bluetooth Print-applet Update-notifier Xscreensaver Conky")
	  sh -c ~/.scripts/Ram/ram2.sh;;
    *)
esac
exit 0
