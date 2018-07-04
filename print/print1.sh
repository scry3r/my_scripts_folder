#!/bin/bash

DEFAULT_PRINTER=$(lpstat -d)

PRINTER=$(zenity --title="Choix de l'imprimante"  --entry --text="Indiquez le nom de l'imprimante tel que dans le gestionnaire d'impression" --entry-text="${DEFAULT_PRINTER}")

for URI in $NAUTILUS_SCRIPT_SELECTED_URIS; do
	libreoffice --nologo -p "${PRINTER}" "${URI}";
done
exit 0