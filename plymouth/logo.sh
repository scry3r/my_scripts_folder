#!/bin/bash
xfce4-terminal -x sh -c "sudo rsync -a /usr/share/plymouth-backup/themes/xubuntu-logo/* /usr/share/plymouth/themes/xubuntu-logo/; sudo rsync -a /usr/share/plymouth-backup/themes/xubuntu-text/* /usr/share/plymouth/themes/xubuntu-text/; sudo update-initramfs -u; notify-send -i ~/.scripts/Wall/logo2.png 'Plymouth Logo Voyager Ok'; bash"
exit