#!/bin/bash
set -e

function getPanelIdImpl() {
  # get panel id
  PANEL="`wmctrl -l | sed -n -e '/ xfce4-panel$/ s_ .*$__ p' | sed -n -e $1' p'`"
}

function getPanelId() {
  # eventually await the panel to appear
  getPanelIdImpl $1
  while [ x = x$PANEL ] ;do
    sleep 0.5s
    getPanelIdImpl $1
  done
}

function putPanelDown() {
  PANEL=""
  getPanelId $1
  wmctrl -i -r $PANEL -b add,below
}

# call the program with a list of panel numbers as arguments
# for example, xfce4-fix-panel 1 2 3
# for the first three panels
for i in $* ;do
  putPanelDown $i
done