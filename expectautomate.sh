#!/bin/bash

username="username"
password="password"
enpassword="enablepassword"
enpassword2="enablepassword2"

# IP-адрес берём из буфера обмена
ip=$(xsel -p)
re="^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$"

# Убираем всё ненужное от ip-адреса
ip=`echo $ip | sed -e 's/^[ \t]+|[ \t]+$//g'`
ip=`echo $ip | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}'`

# проверяем правильный ли ip-адрес это
if [[ ! $ip =~ $re ]] || [[ "${#ip}" -ge 16 ]] || [[ "${#ip}" -eq 0 ]]; then
    notify-send "Telnet" "Error while extracting IP address"   
                                               -u normal   
                                               -i gtk-dialog-warning   
                                               -t 8000
    exit 0;
fi

# проверяем доступность хоста
if ( ! fping -c1 -t500 $ip &>/dev/null ); then
    notify-send "Telnet" "Host $ip not available. Check connection."   
                                               -u normal   
                                               -i gtk-dialog-warning   
                                               -t 8000
    exit 1
fi

# В этой переменной храним собственно сам скрипт
commands="
spawn telnet $ip
expect {
    # Cisco
    \"User Access Verification\" {
        send \"$username\n\"
        expect \"Password: \"
        send \"$password\n\"
        send \"enable\n\"
        send \"$enpassword\"
    }

    # Some other switch\router
    \"Station's information:\" {
        send \"$username\n\"
        expect \"PassWord:\"
        send \"$password\n\"
        send \"enable\n\"
        send \"$enpassword2\n\"
    }

    # and so on...
}
interact
"

gnome-terminal --geometry 120x30+30+20   
              --title "Telnet to $ip"   
              --execute /usr/bin/expect -c "$commands"
