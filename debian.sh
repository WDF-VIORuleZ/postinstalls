#!/bin/bash
 
printf "Post installing setup-script for debain 9 strecth"
 
printf "username> "
read username
 
if [ "$(id -u)" == 0];then
    if [ id -nG $username | grep -qw "sudo" ];then
        printf "$username is already member of he sudoers group\n"
    else
        apt-get install sudo
        usermod -aG sudo $username
    fi
 
    # installing important base packages and drivers debian 9 stretch
    # non-free wifi drivers
    add-apt-repository "deb http://httpredir.debian.org/debian/ stretch main contrib non-free"
    apt-get update && apt-get install -y firmware-iwlwifi
    modprobe -r iwlwifi
    modprobe iwlwifi
 
    # installing basics (free)
    apt-get instal -y git g++ python2 pythton3 python-pip curl wget nc wicd-client zsh vim software-properties-common apt-transport-https build-essential
 
    # installing microsoft VS CODE (non-free)
    curl -sSL https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
    add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
    apt-get update && apt-get install -y code
 
    ## custom extensions and mod-packages
 
    # oh-my-zsh::https://github.com/robbyrussell/oh-my-zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
 
    # ultimate vimrc::https://github.com/amix/vimrc
    git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
    sh ~/.vim_runtime/install_awesome_vimrc.sh
 
    # xorg and window-manager
    apt-get install xorg i3 i3-blocks gdb
 
    # termite terminal emulator
    sudo apt-get install -y libgtk-3-dev gtk-doc-tools gnutls-bin valac intltool libtool libpcre2-dev libglib3.0-cil-dev libgnutls28-dev libgirepository1.0-dev libxml2-utils gperf
 
 
    git clone --recursive https://github.com/thestinger/termite.git
    git clone https://github.com/thestinger/vte-ng.git
 
    echo export LIBRARY_PATH="/usr/include/gtk-3.0:$LIBRARY_PATH"
    cd vte-ng && ./autogen.sh && make && sudo make install
    cd ../termite && make && sudo make install
    sudo ldconfig
    sudo mkdir -p /lib/terminfo/x; sudo ln -s /usr/local/share/terminfo/x/xterm-termite /lib/terminfo/x/xterm-termite
 
    sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/local/bin/termite 60
 
 
else
    printf "[-] $username \'s UID is not root. Permission denied"
fi