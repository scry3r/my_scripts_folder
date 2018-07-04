#!/bin/sh
git clone -b master git://git.sv.gnu.org/emacs.git
git checkout emacs-25.3
sudo apt install --no-install-recommends texinfo
sudo apt install libgtk-3-dev libxpm-dev libjpeg8-dev libgif-dev libtiff5-dev libtinfo-dev librsvg2-dev libmagickwand-dev libacl1-dev libgnutls-dev
# ./autogen.sh
# ./configure
make bootstrap
# if you wish to use clang to compile, use the following instead
# make CC=clang CFLAGS='-g3 -O2 -rtlib=compiler-rt' bootstrap
make check
sudo make install
