#!/bin/bash
# License GPL
# by rodofr@ - Voyager Live
# test si on est root
test=`whoami`
if [ "$DISPLAY" ]; then
    gksudo "sed -i 's|duckduckgo.com|www.google.com/search|g;s|www.qwant.com/|www.google.com/search|g' /.startpage/0/js/script.js /.startpage/1/js/script.js /.startpage/2/js/script.js /.startpage/3/js/script.js /.startpage/4/js/script.js /.startpage/5/js/script.js /.startpage/6/js/script.js /.startpage/7/js/script.js /.startpage/8/js/script.js /.startpage/9/js/script.js /.startpage/10/js/script.js /.startpage/11/js/script.js /.startpage/12/js/script.js /.startpage/13/js/script.js /.startpage/14/js/script.js /.startpage/15/js/script.js /.startpage/16/js/script.js /.startpage/17/js/script.js /.startpage/18/js/script.js /.startpage/19/js/script.js /.startpage/20/js/script.js /.startpage/21/js/script.js /.startpage/22/js/script.js /.startpage/23/index.html /.startpage/24/index.html /.startpage/25/js/script.js /.startpage/26/js/script.js /.startpage/27/js/script.js"
    notify-send -i ~/.scripts/Wall/logo2.png 'Google Startpage Ok'
fi
exit