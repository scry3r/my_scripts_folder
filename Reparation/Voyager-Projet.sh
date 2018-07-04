#! /bin/bash
# License GPL
# by rodofr@ - Voyager Live
box=$(yad --title=Reparation --window-icon="/usr/share/xfce4/voyager/p1.png" --image="/usr/share/xfce4/voyager/Voyager0.png" --image-on-top --separator="" --width=320 --height=490 --list --radiolist --no-headers --directory --column="1" --column="option" --print-column 2 true "Reset Windows Xfce" false "Reset Panel Xfce" false "<span color='red'>Purge Cache Home</span>" false "<span color='red'>Purge Cache Sessions</span>" false "<span color='red'>Purge Cache Kodi Media Center</span>" false "<span color='red'>Purge Cache Pulse Audio</span>" false "<span color='red'>Purge Cache Impulse</span>" false "<span color='red'>Purge Cache Moc Audio</span>" false "<span color='magenta'>Sensors-detect Temp</span>" false "<span color='magenta'>Restore Lost Data</span>" false "<span color='blue'>Conky Configuration</span>" false "<span color='blue'>Plymouth Voyager Logo</span>" false "<span color='blue'>Bash aliases + Meteo</span>" false "<span color='green'>Startpage Configuration</span>" false "<span color='green'>Startpage Google Duckduckgo Qwant</span>" false "Voyager Services minimum")

case $box in
        "Reset Windows Xfce")
 	  exec xfwm4 --replace & sleep 2; sh -c ~/.scripts/Reparation/return.sh;;
        "Reset Panel Xfce")
          xfce4-panel --restart & sleep 2; sh -c ~/.scripts/Reparation/return.sh;;
	"<span color='red'>Purge Cache Home</span>")
	  sh -c ~/.scripts/Reparation/cache.sh && sh -c ~/.scripts/Reparation/return.sh;;
	"<span color='red'>Purge Cache Sessions</span>")
	  sh -c ~/.scripts/Reparation/supprimersessionxfce4.sh && sh -c ~/.scripts/Reparation/return.sh;;
	"<span color='red'>Purge Cache Kodi Media Center</span>")
	  sh -c ~/.scripts/Reparation/kodi.sh && sh -c ~/.scripts/Reparation/return.sh;;
       "<span color='red'>Purge Cache Pulse Audio</span>")
          sh -c ~/.scripts/Reparation/pulse.sh && sh -c ~/.scripts/Reparation/return.sh;;
	"<span color='red'>Purge Cache Impulse</span>")
          sh -c ~/.scripts/Reparation/Impulse.sh&& sh -c ~/.scripts/Reparation/return.sh;;
	"<span color='red'>Purge Cache Moc Audio</span>")
          sh -c ~/.scripts/Reparation/moc.sh && sh -c ~/.scripts/Reparation/return.sh;;	
	"<span color='magenta'>Sensors-detect Temp</span>")
          xfce4-terminal -x sh -c "sudo sensors-detect" && sh -c ~/.scripts/Reparation/return.sh;;
	"<span color='magenta'>Restore Lost Data</span>")
	  xfce4-terminal -x sh -c "sudo photorec" && sh -c ~/.scripts/Reparation/return.sh;;
	"<span color='blue'>Conky Configuration</span>")
          sh -c ~/.scripts/Conky/config.sh & sleep 2; sh -c ~/.scripts/Reparation/return.sh;;
	"<span color='blue'>Plymouth Voyager Logo</span>")
          sh -c ~/.scripts/plymouth/logo.sh;;
	"<span color='blue'>Bash aliases + Meteo</span>")
          mousepad ~/.bash_aliases && sh -c ~/.scripts/Reparation/return.sh;;
"<span color='green'>Startpage Configuration</span>")
          sh -c ~/.scripts/startpage/config.sh & sleep 2; sh -c ~/.scripts/Reparation/return.sh;;
"<span color='green'>Startpage Google Duckduckgo Qwant</span>")
          sh -c ~/.scripts/startpage/privateconf.sh & sleep 2; sh -c ~/.scripts/Reparation/return.sh;;
	"Voyager Services minimum")
          sh -c ~/.scripts/Ram/services.sh & sleep 2; sh -c ~/.scripts/Reparation/return.sh;;
    *)
        exit 0
esac
exit 0
