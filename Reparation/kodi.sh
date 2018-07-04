#!/bin/bash
rm -r ~/.kodi/*
sleep1
rsync -a /$HOME/.backup/.kodi/* /$HOME/.kodi/
notify-send -i ~/.scripts/Wall/logo2.png 'Purge Kodi Media Center' 'OK'