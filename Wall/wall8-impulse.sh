#!/bin/bash
# License GPL
# by rodofr Live voyager
# Modified by metalux for dynamic change wallpapers
# V3.0 par metalux pour Voyager 16.04
# Display the action selector

pgrep -f ImpulseScreenlet.py && pkill -9 -f ImpulseScreenlet.py ||  screenletsd --cli run Impulse
