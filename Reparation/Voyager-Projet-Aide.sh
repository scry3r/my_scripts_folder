# License GPL
# by rodofr - Voyager Live
#!/bin/bash
echo "Voyager Projet Aide :
-  Reset fenêtre Xfce
Regénération des fenêtres (Windows) qui auraient perdues la 3D, leurs contours...

-  Reset Panel Xfce
Regénération du panel pour des icones, applets en conflits ou perdus...

-  Purge Caches Pulse Audio, Moc, Home et Sessions
Nettoyage des caches qui parfois empêchent les logiciels ou des cammandes de fonctionner correctement. Reconnectez-vous à la session.

-  Sensors-detect Température
Detection des modules de températures par sensors. Obligatoire pour utiliser Psensor ou autres logiciels de température. Se fait par terminal et automatisé. Répondre par oui/Yes

-  Récupérations Données perdues
Par terminal avec testdisk et photorec. reporter-vous à l'aide Ubuntu

-  Contrôle Réparation des partitions
Annalyse et répare vos partitions. redémarrer l'ordinateur"
echo
echo "Appuyer la touche <Entrée> pour sortir ..."
    read touche
    case $touche in
    *)    echo "Fin du script..."
    ;;
    esac
exit 0
# 