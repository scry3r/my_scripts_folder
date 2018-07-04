#!/bin/bash
rm -r ~/.screenlets
rm -r ~/.config/screenlets
sleep2
rsync -a /$HOME/.backup/.screenlets /$HOME/.
rsync -a /$HOME/.backup/.config/screenlets /$HOME/.config/
notify-send -i ~/.scripts/Wall/logo2.png 'Purge Impulse' 'OK'

