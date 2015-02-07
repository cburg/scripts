#!/bin/bash


# Download Deb Packages
wget -P ~/Downloads https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
wget -P ~/Downloads http://repo.steampowered.com/steam/archive/precise/steam_latest.deb
wget -P ~/Downloads http://c758482.r82.cf2.rackcdn.com/sublime-text_build-3065_amd64.deb
wget -P ~/Downloads http://developer.download.nvidia.com/compute/cuda/6_5/rel/installers/cuda_6.5.14_linux_64.run
wget -P ~/Downloads http://us.download.nvidia.com/XFree86/Linux-x86_64/346.35/NVIDIA-Linux-x86_64-346.35.run


# Install some of the above packages
sudo dpkg -i ~/Downloads/google-chrome-stable_current_amd64.deb
sudo dpkg -i ~/Downloads/sublime-text_build-3065_amd64.deb


# Add our repositories
sudo add-apt-repository ppa:videolan/stable-daily
sudo add-apt-repository ppa:terry.guo/gcc-arm-embedded
sudo add-apt-repository ppa:daniel.pavel/solaar
sudo add-apt-repository ppa:tuxpoldo/btsync
sudo add-apt-repository ppa:chris-lea/node.js
sudo add-apt-repository ppa:ubuntuhandbook1/birdfont


# Update to the latest
sudo apt-get update
sudo apt-get upgrade

# Development Stuff
sudo apt-get install \
        gcc g++ pkg-config flex bison texinfo doxygen libxml-parser-perl \
        intltool dos2unix fakeroot yasm encfs autconf automake libtool \
        libglib2.0-dev gperf libc6-dev-i386 lib32ncurses5-dev zlib1g:i386 \
        lib32stdc++6 xutils-dev xfonts-utils gdb valgrind python python3 \
        doxygen cpp vim binutils coreutils make arm-none-eabi-gcc \
        arm-none-eabi-gdb git exuberant-ctags libncurses5-dev \
        python-software-properties linux-headers 


# Install Node.js Stuff
sudo apt-get install nodejs

sudo npm install -g less
sudo npm install -g uglifyjs
sudo npm install hogan.js

# ensure we own ~/.npm, prevents build errors
sudo chown -R $(whoami) ~/.npm

# needed for freedesktop's fontconfig...isn't used for anything
sudo mkdir -p /var/cache/fontconfig

# Utilities
sudo apt-get install \
        solaar btsync btsync-gui



# Applications
sudo apt-get install \
        vlc picard soundconverter anki handbrake gimp audacity birdfont ardour



# libraries
sudo apt-get install \
        gstreamer0.10-fluendo-mp3 gstreamer0.10-plugins-base \
        gstreamer0.10-plugins-good gstreamer0.10-plugins-bad \
        gstreamer0.10-plugins-ugly gstreamer1.0-fluendo-mp3 \
        gstreamer1.0-plugins-base gstreamer1.0-plugins-good \
        gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly libdvdcss
        
