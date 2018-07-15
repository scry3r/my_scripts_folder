#!/bin/sh

sudo apt remove --purge vim vim-runtime vim-gnome vim-tiny vim-gui-common -q -y

sudo apt autoremove -y

sudo apt install liblua5.1-dev luajit libluajit-5.1 python-dev ruby-dev libperl-dev libncurses5-dev libatk1.0-dev libx11-dev libxpm-dev libxt-dev python3-dev -q -y

#Optional: so vim can be uninstalled again via `dpkg -r vim`
sudo apt install checkinstall

sudo rm -rf /usr/local/share/vim /usr/bin/vim

cd ~/.scripts
#rm -rf ~/.scripts/vim/
git clone https://github.com/vim/vim
cd vim
git pull && git fetch

#In case Vim was already installed
cd src
make distclean
cd ..

./configure --prefix=/usr/local --enable-multibyte \
--enable-perlinterp \
--enable-rubyinterp \
--enable-pythoninterp \
--enable-python3interp \
--enable-luainterp \
--with-luajit \
--enable-cscope \
--enable-gui=auto \
--with-features=huge \
--with-x \
--enable-fontset \
--enable-largefile \
--disable-netbeans \
--with-compiledby="Max"

make && sudo make install

rm -rf ~/.scripts/vim/
