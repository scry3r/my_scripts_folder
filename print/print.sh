#!/usr/bin/env bash
DEFAULT_PRINTER=$(lpstat -d)

PRINTER=$(zenity --title="Choix de l'imprimante"  --entry --text="Indiquez le nom de l'imprimante tel que dans le gestionnaire d'impression" --entry-text="${DEFAULT_PRINTER}")

TmpFolder="/tmp/$RANDOM"
mkdir $TmpFolder

IFS=$(echo -en "\n\b")
for File in $*
do
  case ${File,,} in
    *.doc|*.docx|*.xls|*.xlsx|*.odt|*.ods|*.pdf)
      libreoffice --nologo -p $File;;
    *.jpg|*.jpeg|*.png|*.tiff|*.tif|*.gif)
      NewName="$RANDOM"
      convert $File $TmpFolder/$NewName.pdf
      libreoffice --nologo -p $TmpFolder/$NewName.pdf;; # I guess, you can replace libreoffice with lp
    *.ps|*.txt)
      lp $File;;
  esac
done

rm -rf $TmpFolder

exit 0