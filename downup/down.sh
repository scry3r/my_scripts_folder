#!/bin/bash
# License GPL
# by rodofr Live voyager mod by Metalux
# Display the action selector

pid=$(pgrep -f conkyrc29 &)
ps -p $pid && kill $pid || conky -c "$HOME/.conky/graph/conky2/conkyrc29" &



