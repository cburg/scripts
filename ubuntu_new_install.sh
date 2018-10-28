#!/bin/bash

SCRIPTROOT="$( dirname "${BASH_SOURCE[0]}" )"

#####################################################################
# Development Packages
#####################################################################
DEVELOPMENT_PACKAGES=(
    # Applications
    vim
    emacs
    git
    make
    autoconf
    automake
    exuberant-ctags
    screen
    # General
    gcc
    g++ 
    cpp
    gdb
    valgrind
    doxygen
    binutils
    coreutils
    # Python
    python
    python-numpy
    python-matplotlib
    python-software-properties
    python3
    python3-numpy
    python3-matplotlib
    python3-software-properties
    # Misc.
    lib32ncurses5-dev
    libncurses5-dev
    linux-headers-`uname -r`
)

MISC_DEVELOPMENT_PACKAGES=(
    # Multimedia
    libtag1v5
    libtag1-dev
    # Misc.
    pkg-config 
    flex 
    bison
    texinfo
    doxygen
    libxml-parser-perl
    intltool
    dos2unix
    fakeroot
    yasm
    encfs
    libtool
    libglib2.0-dev
    gperf
    libc6-dev-i386
    zlib1g:i386
    lib32stdc++6
    xutils-dev
    xfonts-utils
    libgl1-mesa-dev
    dh-modaliases
    execstack
    debhelper
    dkms
)

#####################################################################
# Language
#####################################################################
LANGUAGES=(
    anthy
    anthy-common
    gijten
    ibus-anthy
)


#####################################################################
# Utilities
#####################################################################
UTILITIES=(
    solaar
    syncthing
    ssh
    openvpn
)

#####################################################################
# Applications
#####################################################################
APPLICATIONS=(
    vlc
    picard
    soundconverter
    handbrake
    gimp
    inkscape
    synaptic
    freecad
    openscad
    blender
)

#####################################################################
# Multimedia
#####################################################################
MULTIMEDIA=(
    gstreamer1.0-fluendo-mp3
    gstreamer1.0-plugins-base
    gstreamer1.0-plugins-good
    gstreamer1.0-plugins-bad
    gstreamer1.0-plugins-ugly
    libdvdcss2
)

#####################################################################
# Multimedia
#####################################################################
PREREQUISITES=(
    curl
)

function install_prereqs () {
    echo "install_prereqs"
    sudo apt-get -y --ignore-missing install ${PREREQUISITES[*]}
}

function update_repos () {
    echo "update_repos"
    install_prereqs

    # vlc
    wget -O - http://download.videolan.org/pub/debian/videolan-apt.asc | sudo apt-key add -
    sudo add-apt-repository -y 'deb http://download.videolan.org/pub/debian/stable/ /'

    # syncthing
    curl -s https://syncthing.net/release-key.txt | sudo apt-key add -
    echo 'deb http://apt.syncthing.net/ syncthing release' | sudo tee /etc/apt/sources.list.d/syncthing.list
}

function install_packages () {
    echo "install_packages"
    install_prereqs

    # google-chrome
    sudo dpkg -i ~/Downloads/google-chrome-stable_current_amd64.deb
    sudo apt-get -f install

    # install steam
    sudo dpkg -i ~/Downloads/steam.deb
    sudo apt-get -f install

    ALLPACKAGES=(
        "${DEVELOPMENT_PACKAGES[*]}"
        "${MULTIMEDIA[*]}"
        "${APPLICATIONS[*]}"
        "${UTILITIES[*]}"
        "${LANGUAGES[*]}"
    )

    # Setup log file for dumping the 
    DATETIME=`date +"%Y%m%d_%H%M%S"`
    INSTALL_LOG_DIR=$SCRIPTROOT/install_packages
    mkdir -p $INSTALL_LOG_DIR
    INSTALL_LOG_FILE=$INSTALL_LOG_DIR/$DATETIME.log
    echo "" > $INSTALL_LOG_FILE

    for i in ${ALLPACKAGES[*]}; do
        echo "Installing $i..." | tee -a $INSTALL_LOG_FILE
        echo "--------------------------------------------" | tee -a $INSTALL_LOG_FILE
        sudo apt-get -y --ignore-missing install $i 2>> $INSTALL_LOG_FILE
        echo "" >> $INSTALL_LOG_FILE
    done
}

function download_packages () {
    echo "download_packages"

    wget -P ~/Downloads https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    wget -P ~/Downloads https://steamcdn-a.akamaihd.net/client/installer/steam.deb

    # For now, we'll use Qt libraries in the Ubuntu repositories
    # wget -P ~/Downloads http://download.qt.io/official_releases/online_installers/qt-unified-linux-x64-online.run
}

function update_configs () {
    echo "update_configs"

    # Update configs
    $SCRIPTROOT/configs.sh restore
    # Update bashrc 
    sed -i -n -e '1,/#BEGIN_CUSTOM/{ /#BEGIN_CUSTOM/d; p }' -e '/#END_CUSTOM/,${ /#END_CUSTOM/d; p }' ~/.bashrc
    cat bashrc.custom >> ~/.bashrc
}

function full () {
    echo "full"
    install_prereqs
    download_packages
    update_repos
    install_packages
    update_configs
}

# Parameters
#   -f|--full
#   -i|--install-packages
#   -r|--update-repos
#   -d|--download-packages
#   -c|--update-configs

while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -f|--full)
    full
    break # If full, we don't want to re-run everything
    ;;

    -i|--install-packages)
    install_packages
    shift # past argument
    ;;

    -r|--update-repos)
    update_repos
    shift # past argument
    ;;

    -d|--download-packages)
    download_packages
    shift # past argument
    ;;

    -c|--update-configs)
    update_configs
    shift # past argument
    ;;

    *)    # unknown option
    shift # past argument
    ;;
esac
done
