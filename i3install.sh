#!/bin/bash

# run with sudo

#-------------------------------------------------------------------------------

export DEBIAN_FRONTEND=noninteractive
apt-get update -q
apt-get upgrade -q -y

# depencies of i3-gaps
add-apt-repository ppa:aguignard/ppa -y
apt-get update -q
apt-get install -q -y   -o Dpkg::Options::="--force-confdef" \
                        -o Dpkg::Options::="--force-confold" \
git automake libtool libxcb-xrm0 libxcb-xrm-dev

apt-get install -q -y   -o Dpkg::Options::="--force-confdef" \
                        -o Dpkg::Options::="--force-confold" \
libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev \
libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev \
libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev \
libxkbcommon-dev libxkbcommon-x11-dev autoconf


# install i3-gaps from source

# clone the repository
git clone https://www.github.com/Airblader/i3 i3-gaps
cd i3-gaps
# compile & install
autoreconf --force --install
rm -rf build/
mkdir -p build && cd build/
# Disabling sanitizers is important for release versions!
# The prefix and sysconfdir are, obviously, dependent on the distribution.
../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers
make
make install

# install misc. i3 packages
apt-get install -q -y   -o Dpkg::Options::="--force-confdef" \
                        -o Dpkg::Options::="--force-confold" \
i3lock i3status dmenu dunst

# purge apps
apt-get purge -q -y firefox libreoffice* gnome-calculator gnome-calendar gnome-screenshot gnome-software gnome-sudoku gnome-system-monitor gnome-system-log gnome-mahjongg gnome-disk-utility gnome-mines gnome-orca gnome-power-manager thunderbird cheese aisleriot nautilus zeitgeist-core zeitgeist-datahub checkbox-* gedit totem rhythmbox yelp baobab deja-dup onboard shotwell vim* notify-osd

# basic apps
add-apt-repository ppa:dawidd0811/neofetch -y
add-apt-repository ppa:nilarimogard/webupd8 -y
add-apt-repository ppa:numix/ppa -y
sudo add-apt-repository ppa:atareao/telegram -y
apt-get update -q
apt-get install -q -y   -o Dpkg::Options::="--force-confdef" \
                        -o Dpkg::Options::="--force-confold" \
neofetch xsettingsd feh htop mlocate rxvt-unicode ranger w3m-img mpd ncmpcpp rofi compton surf mpv dnsutils htop vim nitrogen redshift \
redshift pcmanfm lxappearance scrot xclip gawk bmon nethogs etherape gdebi moc ubuntu-restricted-addons ubuntu-restricted-extras \
openssh-server network-manager-iodine network-manager-vpnc-gnome network-manager-vpnc network-manager-strongswan network-manager-ssh-gnome network-manager-ssh network-manager-pptp-gnome \
network-manager-pptp network-manager-openvpn-gnome network-manager-openvpn network-manager-iodine-gnome network-manager-openconnect-gnome network-manager-openconnect nmap dnsutils \
numix-icon-theme-circle arandr volti pavucontrol parcellite blueman xfce4-power-manager tlp tlp-rdw \
classicmenu-indicator indicator-keylock gparted undistract-me telegram lynis debian-goodies \
apt-listchanges gir1.2-appindicator3-0.1 gir1.2-notify-0.7 python-gobject wmctrl openvpn \
python-urwid python-requests mercurial meld rkhunter needrestart debsecan fail2ban debsums

# Copy system scripts
cp -rf ~/.scripts/i3exit /usr/bin/
cp -rf ~/.scripts/i3-scrot /usr/bin/
cp -rf ~/.scripts/blurlock /usr/bin/
cp -rf ~/.scripts/i3status.conf /etc/

# *.deb apps
cd ~/Downloads/
sudo dpkg -i *.deb
sudo apt install -q -f -y
