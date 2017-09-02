#!/bin/bash

# Simple script to automate a fresh Ubuntu install. Aside from some initial
# passwords and menus, it should for the most part be automated. 


# Download Deb Packages
wget -P ~/Downloads https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
wget -P ~/Downloads http://repo.steampowered.com/steam/archive/precise/steam_latest.deb
wget -P ~/Downloads http://download.qt.io/official_releases/online_installers/qt-unified-linux-x64-online.run

# Need to update the keys and repository list. When first installing
# libappindicator1 there was a warning saying the package couldn't be authenticated
sudo apt-key update
sudo apt-get update

# Install dependencies needed by Google Chrome. 
sudo apt-get install -y libgconf2-4 libnss3-1d libxss1 libappindicator1 libindicator7

# Install Chrome, Sublime, Qt Libraries, and Rust
sudo dpkg -i ~/Downloads/google-chrome-stable_current_amd64.deb
#sudo dpkg -i ~/Downloads/sublime-text_build-3103_amd64.deb

chmod +x ~/Downloads/qt-unified-linux-x64-online.run
sudo ~/Downloads/qt-unified-linux-x64-online.run & # Allow installation to be done in 
                                                      # background.
                                            
# Add our repositories
# The gcc-arm and node.js repo's aren't strictly needed as there are versions in the default repositories.
# They are being left in in the event that we want to update to newer versions in the future.
#sudo add-apt-repository ppa:team-gcc-arm-embedded/ppa
#sudo add-apt-repository -y 'deb http://ppa.launchpad.net/tuxpoldo/btsync/ubuntu vivid main'
#sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys D294A752 # Get key for btsync
#sudo add-apt-repository -y 'deb http://ppa.launchpad.net/chris-lea/node.js/ubuntu utopic main'
#sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C7917B12 # Get key for node.js
#sudo add-apt-repository -y 'deb http://ppa.launchpad.net/ubuntuhandbook1/birdfont/ubuntu vivid main'
#sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 852541CB # Get key for birdfont 
#sudo add-apt-repository -y 'deb http://ppa.launchpad.net/daniel.pavel/solaar/ubuntu trusty main'
#sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 06524FBA # Get key for solaar
sudo add-apt-repository -y 'deb http://download.videolan.org/pub/debian/stable/ /'
wget -O - http://download.videolan.org/pub/debian/videolan-apt.asc | sudo apt-key add -


# Add Syncthing (steps retrieved from apt.syncthing.net)
# Add the release PGP keys:
sudo apt-get install curl
curl -s https://syncthing.net/release-key.txt | sudo apt-key add -

# Add the "release" channel to your APT sources:
echo "deb http://apt.syncthing.net/ syncthing release" | sudo tee /etc/apt/sources.list.d/syncthing.list



# Update to the latest
sudo apt-get update
sudo apt-get upgrade -y

# Development Stuff
sudo apt-get install -y --ignore-missing \
        gcc g++ pkg-config flex bison texinfo doxygen libxml-parser-perl \
        intltool dos2unix fakeroot yasm encfs autoconf automake libtool \
        libglib2.0-dev gperf libc6-dev-i386 lib32ncurses5-dev zlib1g:i386 \
        lib32stdc++6 xutils-dev xfonts-utils gdb valgrind python python3 \
        doxygen cpp vim binutils coreutils make git exuberant-ctags \
        libncurses5-dev python-software-properties linux-headers-`uname -r` \
        gcc-arm-embedded screen libgl1-mesa-dev \
        python3-numpy python-numpy python3-matplotlib python-matplotlib \
        dh-modaliases execstack debhelper dkms


# Install Node.js
sudo apt-get install -y nodejs
sudo chown -R $(whoami) ~/.npm


# Japanese Stuff
sudo apt-get install -y --ignore-missing \
         anki anthy anthy-common gijten ibus-anthy


# Utilities
sudo apt-get install -y --ignore-missing \
        solaar syncthing openvpn ssh

# Applications
sudo apt-get install -y --ignore-missing \
        vlc picard soundconverter anki handbrake gimp audacity birdfont ardour \
        inkscape synaptic freecad openscad blender 



# Multimedia libraries
sudo apt-get install -y --ignore-missing \
        gstreamer0.10-plugins-base gstreamer0.10-plugins-good \
        gstreamer1.0-fluendo-mp3 \
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
        
