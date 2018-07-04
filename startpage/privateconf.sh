#! /bin/bash
# License GPL
# by rodofr@ - Voyager Live
box=$(yad --title=Search --window-icon="/usr/share/xfce4/voyager/p1.png" --image="/usr/share/xfce4/voyager/Voyager0.png" --image-on-top --separator="" --width=320 --height=180 --list --radiolist --no-headers --directory --column="1" --column="option" --print-column 2 true "Google Search Startpage" false "Duckduckgo Search Startpage" false "Qwant Search Startpage")

case $box in
        "Google Search Startpage")
	  sh -c ~/.scripts/startpage/private.sh;;
	"Duckduckgo Search Startpage")
	  sh -c ~/.scripts/startpage/private1.sh;;
	"Qwant Search Startpage")
	  sh -c ~/.scripts/startpage/private2.sh;;
    *)
esac
exit 0
