#!/usr/bin/bash
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi
hash apt-get 2>/dev/null || { echo >&2 "Your system is not Debian based. Please\
 go to https://github.com/Arengorn/DevStart and request support."; exit 1; }
cd ~/ || exit
mkdir ~/.devsetup
cd ~/.devsetup || exit
# General requirements
echo "Installing Pre-Requisites"
apt-get install wget git uncrustify ctags apt-get install libncurses5-dev \
libgnome2-dev libgnomeui-dev libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev ruby-dev python3 fish \
clang -y
# Atom
echo "Installing Atom"
if hash atom 2>/dev/null; then
    :
else
    wget https://atom.io/download/deb
    atom=$(ls atom*)
    dpkg --install $atom
fi
apm install atom-beautify file-icons git-plus indent-guide-improved \
language-arduino language-markdown linter linter-flake8 minimap minimap-git-diff
pip3 install flake8 autopep8
# VIM
echo "Installing VIM"
apt-get remove vim vim-runtime gvim
git clone https://github.com/vim/vim.git
cd vim || exit
./configure --with-features=huge \
            --enable-multibyte \
            --enable-rubyinterp \
            --enable-pythoninterp \
            --with-python-config-dir=/usr/lib/python2.7/config \
            --enable-perlinterp \
            --enable-luainterp \
            --enable-gui=gtk2 --enable-cscope --prefix=/usr
cores=$(grep -c ^processor /proc/cpuinfo)
make -j$cores VIMRUNTIMEDIR=/usr/share/vim/vim74
make install
cd ..
git clone https://github.com/amix/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_awesome_vimrc.sh
echo "if [ -e /usr/share/terminfo/x/xterm-256color ]; then" >> ~/.profile
echo "        export TERM='xterm-256color'" >> ~/.profile
echo "else" >> ~/.profile
echo "        export TERM='xterm-color'" >> ~/.profile
echo "fi" >> ~/.profile
# Python
echo "Installing Python"
python_version=$(python -c 'import platform; print(platform.python_version())')
if [ ${python_version:0:1} != "3" ];then
    echo "alias python=python3" | tee -a ~/.bashrc ~/.config/fish/cofig.fish
    echo "alias pip=pip3" | tee -a ~/.bashrc ~/.config/fish/cofig.fish
else
    :
fi
#Fish
echo "Setting Default Shell to fish"
chsh -s '$(which fish)'
