#!/bin/bash

if [ ! "$#" -eq 1 ]
then
        echo "1 arguments required, $# provided"
        exit 1
fi

if ( ! ping -c1 -i1 -n -s10 -W1 $1  &>/dev/null )
then
        echo "Host $1 not available"
        exit 1
fi


USERNAME="testuser"
PASSWORD="testpass"

DIRLIST=$(expect -c "
    set timeout 3
    spawn ftp $1
    expect \"Name*\"
    send \"$USERNAME\n\"
    expect \"?assword:\"
    send \"$PASSWORD\n\"
    expect \"ftp>\"
    send \"passive\n\"
    expect \"ftp>\"
    send \"ls\n\"
    expect \"ftp>\"
    send \"bye\n\"
")

echo "$DIRLIST" | sed -e '1,14d' | head -n -2 > $1_dirlist.txt
