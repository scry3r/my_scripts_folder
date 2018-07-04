#!/bin/bash
# License GPL
# communauté @Voyager
#Script de rodofr-metalux-Christophe C

#=========================================================================================
# Lignes redondantes dans le script-Création de fonctions
#=========================================================================================

icone() {
sed -i "s|IconSize.*|IconSize=$icon|g" ~/.config/plank/dock1/settings
}
theme() {
sed -i "s|Theme.*|Theme=$theme|g" ~/.config/plank/dock1/settings
}
position() {
sed -i "s|Position.*|Position=$position|g" ~/.config/plank/dock1/settings
}
apparition() {
sed -i "s|HideMode.*|HideMode=$apparition|g" ~/.config/plank/dock1/settings
}
alignement() {
sed -i "s/^Alignment.*/Alignment=$alignement/" ~/.config/plank/dock1/settings
}
verrouil() {
sed -i "s/^LockItems.*/LockItems=$verrouiller/" ~/.config/plank/dock1/settings
}
notify() {
	pgrep xfce4-notifyd && pkill xfce4-notifyd
	notify-send -t 300000 -i plank 'Plank' "Icon $icon \n Style $theme"
}
kill_notif() {
	pgrep xfce4-notifyd && pkill xfce4-notifyd
}

#=========================================================================================
# Initialisation des paramètres de base
#=========================================================================================

icon=$(grep IconSize ~/.config/plank/dock1/settings | cut -d'=' -f2)
icone_origine=$icon
position=$(grep Position ~/.config/plank/dock1/settings | cut -d'=' -f2)
pos_origine=$position
apparition=$(grep HideMode  ~/.config/plank/dock1/settings | cut -d'=' -f2)
apparition_origine=$apparition
alignement=$(grep ^Alignment ~/.config/plank/dock1/settings | cut -d'=' -f2)
alignement_origine=$alignement
theme="$(grep Theme ~/.config/plank/dock1/settings | cut -d'=' -f2)"
theme_origine=$theme

#=========================================================================================
# Lancement de la boucle infinie
#=========================================================================================

while :
  do
	sortie=0

#=========================================================================================
#Test de l'existence de la poubelle
#=========================================================================================

[[ -e ~/.config/plank/dock1/launchers/Corbeille.dockitem ]] && corbeille=" Retirer la poubelle du dock(remove trash)" || corbeille=" Ajouter une poubelle dans le dock(add trash)"

#=========================================================================================
#Test du verrouillage du dock
#=========================================================================================

grep LockItems=false ~/.config/plank/dock1/settings && lock=' Verrouiller le dock(lock)' || lock=' Déverrouiller le dock(unlock)'

#=========================================================================================
#Propose les options de PARAMETRAGE
#=========================================================================================

	PARAM=$(yad --sticky --center --separator="" --print-column=1 --window-icon=/usr/share/xfce4/voyager/p1.png --image=/usr/share/xfce4/voyager/Voyager3.png --list --no-headers --button="QUITTER:1" --title="VOYAGER PLANK" --text "                                        <b><big><big><big></big></big></big></b>" --width=700 --height=340 --column="                       CHOISISSEZ UNE OPTION" " Taille des icones(Icons Size)"  " Position du Dock" " Apparition du Dock" " Alignement du Dock" " Changement du thème" "$corbeille" "$lock" )

#=========================================================================================
#choix optionnel DE LA TAILLE DES ICONES
#========================================================================================= 

	case $PARAM in
		" Taille des icones(Icons Size)") while [[ $sortie -eq 0 ]];do
			notify
			icon=$(yad --sticky --width=700 --height=340 --window-icon=/usr/share/xfce4/voyager/p1.png --image=/usr/share/xfce4/voyager/Voyager4.png --center --button="Tester:0" --button="Confirmer:2" --button="Annuler:252" --separator="" --title=Icons --min-value=24 --max-value=70 --value=$icon --scale --text="TAILLE DES ICONES")
			sortie=$?
			if [[ $sortie -eq 252 ]];then
				icon=$icone_origine	
				icone
        			kill_notif && notify-send -i plank 'Plank' "Annulation.\n Plank Icone $icon restaurée"
			elif [[ $sortie -eq 2 ]];then
				icone
      				kill_notif && notify-send -i plank 'Plank' "Plank Icon $icon sélectionné"
				icone_origine=$icon
			else
				icone
			fi
		done;;

#=========================================================================================
#choix optionnel DE LA POSITION DU DOCK
#=========================================================================================

		" Position du Dock") while [[ $sortie -eq 0 ]];do
			option=( "Gauche(left)" "Droite(Right)" "Haut(Top)" "Bas(Bottom)" )
			position=$(for (( a=0; a<=3; a++ ));do
				[[ $position -eq $a ]] && echo true || echo false
				echo $a
				echo ${option[$a]}
			done | yad --width=700 --height=340 --no-headers --sticky --window-icon=/usr/share/xfce4/voyager/p1.png --image=/usr/share/xfce4/voyager/Voyager5.png --center --button="Tester:0" --button="Confirmer:2" --button="Annuler:252" --separator="" --print-column=2 --hide-column=2 --list --text="<i>Choisissez une option</i>" --title="POSITION" --radiolist  --column="" --column="" --column="Emplacement")	
			sortie=$?
			if [[ $sortie -eq 252 ]];then
				position=$pos_origine
				position
        			kill_notif && notify-send -i plank 'Plank' "Annulation.\n Plank defaut Position"
			elif [[ $sortie -eq 2 ]];then
				position
				pos_origine=$position
			else
        			position
			fi
		done;;

#=========================================================================================
#choix optionnel DU MODE D'APPARITION DU DOCK
#=========================================================================================

		" Apparition du Dock") while [[ $sortie -eq 0 ]];do
			option=("Toujours affiché(Never Hide)" "Masquage intelligent(Intelligent Hide)" "Masquage automatique(Autohide)" "Masquage si une fenêtre est en plein écran(Hid if a window is in full screen)")
			apparition=$(for (( a=0; a<=3; a++ ));do
				[[ $apparition -eq $a ]] && echo true || echo false
				echo $a
				echo ${option[$a]}
			done | yad --width=700 --height=340 --no-headers --sticky --window-icon=/usr/share/xfce4/voyager/p1.png --image=/usr/share/xfce4/voyager/Voyager6.png --center --button="Tester:0" --button="Confirmer:2" --button="Annuler:252" --separator="" --print-column=2 --hide-column=2 --title=Position --list --text="<i>Choisissez une option</i>" --title="APPARITION" --radiolist --column="" --column="" --column="")	
			sortie=$?
			if [[ $sortie -eq 252 ]];then
				apparition=$apparition_origine
        			apparition
        			kill_notif && notify-send -i plank 'Plank' "Annulation.\n Plank defaut Hide Mode"
			elif [[ $sortie -eq 2 ]];then
				apparition
				apparition_origine=$apparition
			else
        			apparition
			fi
		done;;

#=========================================================================================
#choix optionnel DU MODE D'ALIGNEMENT DU DOCK
#=========================================================================================

		" Alignement du Dock") while [[ $sortie -eq 0 ]];do
			option=("Panel Mode" "gauche(left)" "Droite(right)" "Centre(center)")
			alignement=$(for (( a=0; a<=3; a++ ));do
				[[ $alignement -eq $a ]] && echo true || echo false
				echo $a
				echo ${option[$a]}
			done | yad --width=700 --height=340 --no-headers --sticky --window-icon=/usr/share/xfce4/voyager/p1.png --image=/usr/share/xfce4/voyager/Voyager7.png --center --button="Tester:0" --button="Confirmer:2" --button="Annuler:252" --separator="" --print-column=2 --hide-column=2 --title=Position --list --text="<i>Choisissez une option</i>" --title="ALIGNEMENT" --radiolist --column="" --column="" --column="")	
			sortie=$?
			if [[ $sortie -eq 252 ]];then
        			alignement=$alignement_origine
				alignement
        			kill_notif && notify-send -i plank 'Plank' "Annulation.\n Plank defaut Alignement"
			elif [[ $sortie -eq 2 ]];then
				alignement
				alignement_origine=$alignement
			else
        			alignement
			fi
		done;;

#=========================================================================================
#choix optionnel DU THEME
#=========================================================================================


		" Changement du thème") while [[ $sortie -eq 0 ]];do
			notify
			SAUVEIFS=$IFS
			IFS=$'\n'
			LISTE=($(ls ~/.local/share/plank/themes) $(ls /usr/share/plank/themes)) 
			LISTE=($(sort -u <<<"${LISTE[*]}"))
			IFS=$SAUVEIFS 		
			theme=$(for (( a=0; a<${#LISTE[@]}; a++ ));do 
				[[ $theme == ${LISTE[$a]} ]] && echo true || echo false
				echo "${LISTE[$a]}"
			done | yad --width=700 --height=340 --no-headers --sticky --window-icon=/usr/share/xfce4/voyager/p1.png --image=/usr/share/xfce4/voyager/Voyager8.png --center --button="Tester:0" --button="Confirmer:2" --button="Annuler:252" --separator="" --print-column=2 --title "CHOIX DES THEMES" --list --radiolist --text "Choisissez un thème pour Plank" --column="" --column="Theme")
		sortie=$?
			if [[ $sortie -eq 252 ]];then
				theme=$theme_origine
        			theme
        			kill_notif && notify-send -i plank 'Plank' "Annulation.\n Plank theme $theme restauré"
			elif [[ $sortie -eq 2 ]];then
				theme
				kill_notif && notify-send -i plank 'Plank' "Plank Theme $theme sélectionné"
				theme_origine=$theme
			else
       				theme
			fi
		done;;

#=========================================================================================
#choix optionnel d'AJOUT/RETRAIT D'UNE ICONE CORBEILLE DANS LE DOCK
#=========================================================================================

		" Ajouter une poubelle dans le dock(add trash)")
			echo [PlankItemsDockItemPreferences] >> ~/.config/plank/dock1/launchers/Corbeille.dockitem
			echo Launcher=file:///usr/share/xfce4/Corbeille.desktop >> ~/.config/plank/dock1/launchers/Corbeille.dockitem
			[[ ! -e /usr/share/pyshared/trashcli ]]  && gksudo -m "Voyager Plank nécessite l'installation du paquet trash-cli pour utiliser la corbeille dans plank, veuillez entrer votre mot de passe" apt-get install trash-cli;;

		
		" Retirer la poubelle du dock(remove trash)") 
			rm ~/.config/plank/dock1/launchers/Corbeille.dockitem
		;;

#=========================================================================================
#Verrouiller le Dock
#=========================================================================================

		' Verrouiller le dock(lock)')
			verrouiller=true && verrouil
;;
		' Déverrouiller le dock(unlock)')
			verrouiller=false && verrouil
;;
		
#=========================================================================================
#Sortie du script
#=========================================================================================

		*) 	kill_notif && notify-send -i plank 'Plank' "Plank Icone $icon \n Theme $theme sélectionnés"
			exit 1
	esac
done
