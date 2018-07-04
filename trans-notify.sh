#!/bin/sh
text=`xclip -selection primary -o`
trans=`~/.scripts/trans :ru -brief "$text"`
notify-send "$trans"
