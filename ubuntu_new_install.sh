#!/bin/bash

# Simple script to automate a fresh Ubuntu install. Aside from some initial
# passwords and menus, it should for the most part be automated. 


# Download Deb Packages
wget -P ~/Downloads https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
wget -P ~/Downloads http://repo.steampowered.com/steam/archive/precise/steam_latest.deb
wget -P ~/Downloads http://c758482.r82.cf2.rackcdn.com/sublime-text_build-3083_amd64.deb
wget -P ~/Downloads http://download.qt-project.org/official_releases/online_installers/qt-opensource-linux-x64-online.run
wget -P ~/Downloads https://static.rust-lang.org/dist/rust-1.0.0-beta.3-x86_64-unknown-linux-gnu.tar.gz

# Need to update the keys and repository list. When first installing
# libappindicator1 there was a warning saying the package couldn't be authenticated
sudo apt-key update
sudo apt-get update

# Install dependencies needed by Google Chrome. 
sudo apt-get install -y libgconf2-4 libnss3-1d libxss1 libappindicator1 libindicator7

# Install Chrome, Sublime, Qt Libraries, and Rust
sudo dpkg -i ~/Downloads/google-chrome-stable_current_amd64.deb
sudo dpkg -i ~/Downloads/sublime-text_build-3083_amd64.deb

chmod +x ~/Downloads/qt-opensource-linux-x64-online.run
sudo ~/Downloads/qt-opensource-linux-x64-online.run & # Allow installation to be done in 
                                                      # background.
                                            
tar -xzvf ~/Downloads/rust-1.0.0-beta.3-x86_64-unknown-linux-gnu.tar.gz -C ~/Downloads
sudo ~/Downloads/rust-1.0.0-beta.3-x86_64-unknown-linux-gnu/install.sh


# Add our repositories
sudo add-apt-repository -y ppa:videolan/stable-daily
sudo add-apt-repository -y ppa:terry.guo/gcc-arm-embedded
sudo add-apt-repository -y ppa:tuxpoldo/btsync
sudo add-apt-repository -y ppa:chris-lea/node.js
sudo add-apt-repository -y ppa:ubuntuhandbook1/birdfont
sudo add-apt-repository -y 'deb http://ppa.launchpad.net/daniel.pavel/solaar/ubuntu trusty main'
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 06524FBA # Get key for solaar
sudo add-apt-repository -y 'deb http://download.videolan.org/pub/debian/stable/ /'
wget -O - http://download.videolan.org/pub/debian/videolan-apt.asc | sudo apt-key add -


# Update to the latest
sudo apt-get update
sudo apt-get upgrade -y

# Development Stuff
sudo apt-get install -y \
        gcc g++ pkg-config flex bison texinfo doxygen libxml-parser-perl \
        intltool dos2unix fakeroot yasm encfs autoconf automake libtool \
        libglib2.0-dev gperf libc6-dev-i386 lib32ncurses5-dev zlib1g:i386 \
        lib32stdc++6 xutils-dev xfonts-utils gdb valgrind python python3 \
        doxygen cpp vim binutils coreutils make git exuberant-ctags \
        libncurses5-dev python-software-properties linux-headers-`uname -r` \
        gcc-arm-none-eabi screen libgl1-mesa-dev


# Install Node.js
sudo apt-get install -y nodejs
sudo chown -R $(whoami) ~/.npm



# Utilities
sudo apt-get install -y \
        solaar btsync btsync-gui openvpn ssh

# Applications
sudo apt-get install -y \
        vlc picard soundconverter anki handbrake gimp audacity birdfont ardour \
        inkscape synaptic freecad openscad blender



# Multimedia libraries
sudo apt-get install -y \
        gstreamer0.10-fluendo-mp3 gstreamer0.10-plugins-base \
        gstreamer0.10-plugins-good gstreamer0.10-plugins-bad \
        gstreamer0.10-plugins-ugly gstreamer1.0-fluendo-mp3 \
        gstreamer1.0-plugins-base gstreamer1.0-plugins-good \
        gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly libdvdcss2




# Remove Scopes
sudo apt-get remove --purge -y \
        unity-scope-calculator unity-scope-gdrive unity-scope-yelp \
        unity-scope-texdoc unity-scope-devhelp unity-scope-virtualbox \
        unity-scope-audacious unity-scope-clementine unity-scope-tomboy \
        unity-scope-gmusicbrowser unity-scope-guayadeque unity-scope-manpages \
        unity-scope-chromiumbookmarks unity-scope-firefoxbookmarks \
        unity-scope-zotero unity-scope-colourlovers unity-scope-openclipart \
        unity-scope-musique unity-scope-gourmet unity-scope-musicstores \
        unity-scope-video-remote


# Remove unwanted lens'
sudo apt-get remove --purge -y \
        unity-lens-photos unity-lens-music unity-lens-files
        
